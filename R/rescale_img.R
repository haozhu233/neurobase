#' @title Image Rescaler
#' @name rescale_img
#' @param filename filename of image to be read into R or nifti object 
#' @param pngname filename of png of histogram of values of image to be made. For no
#' png - set to NULL (default)
#' @param write.nii logical - should the image be written.  
#' @param outfile if \code{write.nii = TRUE}, filename of output file
#' @param min.val minimum value of image (default -1024 (for CT)).  If no thresholding
#' set to -Inf
#' @param max.val maximum value of image (default 3071 (for CT)).  If no thresholding
#' set to Inf
#' @param ROIformat if TRUE, any values $< 0$ will be set to 0
#' @param writer character value to add to description slot of NIfTI header
#' @param ... extra methods to be passed to \code{\link{writenii}}
#' @description Rescales an image to be in certain value range.  This was created
#' as sometimes DICOM scale and slope parameters may be inconsistent across sites
#' and the data need to be value restricted
#' @return Object of class nifti
#' @importFrom grDevices png dev.off
#' @export
rescale_img = function(filename, 
                       pngname = NULL, 
                       write.nii = FALSE,
                       outfile = NULL,
                       min.val = -1024,
                       max.val = 3071,
                       ROIformat=FALSE, 
                       writer = "dcm2nii", ...){
  
  if (write.nii){
    stopifnot(!is.null(outfile))
  }
  
  img = check_nifti(filename)
  # inter = as.numeric(img@scl_inter)
  # slope = as.numeric(img@scl_slope)
  # img = (img * slope + inter)
  r = range(c(img))
  if (r[1] >= min.val & r[2] <= max.val){
    return(img)
  }
  img[img < min.val] = min.val
  img[img > max.val] = max.val
  img = zero_trans(img)
  if (ROIformat) img[img < 0] = 0
  img = cal_img(img)
  descrip(img) = paste0("written by ", writer, " - ", descrip(img))
  
  img = drop_img_dim(img)
  #### create histograms
  if (!is.null(pngname)){
    options(bitmapType = 'cairo') 
    print(pngname)
    ### remove random percents
    pngname = gsub("%", "", pngname)
    grDevices::png(pngname)
      graphics::hist(img)
    grDevices::dev.off()
  }
  
  if (write.nii) {
    writenii(img, filename = outfile, ...)
  }
  return(img)
}




#' @title Change Data type for img
#' @return object of type nifti
#' @param img nifti object (or character of filename)
#' @param type_string (NULL) character of datatype and bitpix.  Supercedes
#' both datatype and bitpix.  If specified 
#' \code{convert.datatype[[type_string]]} and 
#' \code{convert.bitpix[[type_string]]} will be used.
#' @param datatype (NULL) character of datatype see 
#' \code{\link{convert.datatype}}
#' @param bitpix (NULL) character of bitpix see 
#' \code{\link{convert.bitpix}} 
#' @param trybyte (logical) Should you try to make a byte (UINT8) if image in
#' c(0, 1)?
#' @param warn Should a warning be issued if defaulting to FLOAT32?
#' @description Tries to figure out the correct datatype for image.  Useful 
#' for image masks - makes them binary if
#' @name datatype
#' @export
datatyper = function(img, type_string = NULL,
                     datatype = NULL, bitpix=NULL, trybyte=TRUE,
                     warn = TRUE){
  img = check_nifti(img)
  if (!is.null(type_string)) {
    accepted = names(convert.datatype())
    type_string = toupper(type_string)
    stopifnot(type_string %in% accepted)
    datatype = convert.datatype()[[type_string]]
    bitpix = convert.bitpix()[[type_string]]
  }  
  if (!is.null(datatype) & !is.null(bitpix)) {
    datatype(img) <- datatype
    bitpix(img) <- bitpix
    return(img)
  }
  if (!is.null(datatype) & is.null(bitpix)) {
    stop("Both bitipx and datatype need to be specified if oneis")
  }
  if (is.null(datatype) & !is.null(bitpix)) {
    stop("Both bitipx and datatype need to be specified if oneis")
  }
  #### logical - sign to unsigned int 8
  arr = as(img, "array")
  is.log = inherits(arr[1], "logical")
  if (is.log) {
    datatype(img) <- convert.datatype()$UINT8
    bitpix(img) <- convert.bitpix()$UINT8
    return(img)
  }
  #### testing for integers
  testInteger <- function(img){
    x = c(as(img, "array"))
    test <- all.equal(x, as.integer(x), check.attributes = FALSE)
    return(isTRUE(test))
  }  
  is.int = testInteger(img)
  if (is.int) {
    rr = range(img, na.rm = TRUE)
    ##### does this just for binary mask
    if (all(rr == c(0, 1)) & trybyte) {
      if (all(img %in% c(0, 1))) {
        datatype(img) <- convert.datatype()$UINT8
        bitpix(img) <- convert.bitpix()$UINT8
        return(img)
      }
    }
    signed = FALSE
    if (any(rr < 0)) {
      signed = TRUE
    }
    trange = diff(rr)
    # u = "U"
    mystr = NULL
    num = 16 # default is signed short
    if (is.null(mystr) & trange <= (2 ^ num) - 1 ) {
        # mystr = ifelse(signed, "INT16", "FLOAT32")
      mystr = "INT16"
    }

    num = 32 
    if (is.null(mystr) & trange <= (2 ^ num) - 1 ) {
      mystr = "INT32" # no UINT32 allowed
    }
    
    num = 64
    if (is.null(mystr) & trange <= (2 ^ num) - 1 ) {
      mystr = "DOUBLE64" # Only way to 64 bits is through double
    }
    if (is.null(mystr)) {
      stop(paste0("Cannot determine integer datatype, ", 
                  "may want to recheck data or not use datatyper!"))
    }
    datatype(img) <- convert.datatype()[[mystr]]
    bitpix(img) <- convert.bitpix()[[mystr]]
    return(img)
  } else {
    if (warn) {
      warning("Assuming FLOAT32")
    }
    mystr = "FLOAT32"
    datatype(img) <- convert.datatype()[[mystr]]
    bitpix(img) <- convert.bitpix()[[mystr]]
    return(img)
  }
}



#' @title Resets image parameters for a copied nifti object
#' @return object of type nifti
#' @param img nifti object (or character of filename)
#' @param ... arguments to be passed to \code{\link{datatype}}
#' @description Resets the slots of a nifti object, usually because an image
#' was loaded, then copied and filled in with new data instead of making a 
#' nifti object from scratch.  Just a wrapper for smaller functions 
#' @export
newnii = function(img, ...){
  img = check_nifti(img)
  img = zero_trans(img)
  img = cal_img(img)
  img = datatyper(img, ...)
  return(img)
}

