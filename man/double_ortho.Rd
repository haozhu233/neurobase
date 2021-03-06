% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/double_ortho.R
\name{double_ortho}
\alias{double_ortho}
\title{Double Orthographic Display}
\usage{
double_ortho(x, y = NULL, col.y = gray(0:64/64), NA.x = TRUE,
  mfrow = c(2, 4), add = FALSE, ...)
}
\arguments{
\item{x}{is an object of class nifti or similar.}

\item{y}{is an object of class nifti or similar to be set aside x.}

\item{col.y}{is grayscale (by default).}

\item{NA.x}{Set any values of 0 in \code{x} to \code{NA}}

\item{mfrow}{(numeric) layout of the 3 slices}

\item{add}{Should the y-plot be added or its own plot?  Used
in \code{double_ortho}}

\item{...}{other arguments to \code{\link{ortho2}}}
}
\description{
Copy of \code{oro.nifti}'s \code{\link{orthographic}} function 
with some tweaks such as adding L/R designations for left and right
}
\seealso{
\link{orthographic}
}
