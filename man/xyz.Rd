% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cog.R
\name{xyz}
\alias{xyz}
\title{Image Center of Gravity Wrapper}
\usage{
xyz(...)
}
\arguments{
\item{...}{Arguments ppssed to \code{\link{cog}}}
}
\value{
Vector of length 3
}
\description{
Find Center of Gravity of Image, after thresholding and
take ceiling (wrapper for \code{\link{cog}})
}
\note{
Just a convenience wrapper for \code{cog(ceil=TRUE)}
}
