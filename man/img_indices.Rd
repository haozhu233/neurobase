% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/img_indices.R
\name{img_indices}
\alias{img_indices}
\title{Retrieve Image Indices}
\usage{
img_indices(img, mask = NULL, add_values = FALSE, units = c("index",
  "mm"))
}
\arguments{
\item{img}{Object of class \code{nifti}}

\item{mask}{Mask to be applied for indices the index}

\item{add_values}{Should the value be column-binded to the matrix}

\item{units}{Should the indices be in xyz-coordinates or millimeters.}
}
\value{
Matrix of 3 columns if \code{add_values = FALSE} or 4 columns, 
otherwise.
}
\description{
Extract image xyz indices (in voxels or millimeters), with the
option to append the values
}
