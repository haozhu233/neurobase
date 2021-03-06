% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_img_ext.R
\name{parse_img_ext}
\alias{parse_img_ext}
\title{Parse Image Extensions}
\usage{
parse_img_ext(file)
}
\arguments{
\item{file}{Character filename to parse}
}
\value{
Extension of file
}
\description{
Get image extensions from a filename
}
\examples{
parse_img_ext("blah.nii.gz")
parse_img_ext("blah.mnc")
parse_img_ext("blah.nii")
parse_img_ext("blah")
parse_img_ext("blah.img")
parse_img_ext("blah.hdr")
parse_img_ext("blah.hdr.gz")
}
