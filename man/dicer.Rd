% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dicer.R
\name{dicer}
\alias{dicer}
\title{Calculate Dice from a Table}
\usage{
dicer(tab, verbose = TRUE)
}
\arguments{
\item{tab}{table or matrix that is 2 by 2}

\item{verbose}{should the Dice be printed before returned?}
}
\value{
Numeric scalar (one number)
}
\description{
Simple wrapper to calculate the Dice Coefficient/Similarity Index
from a table
}
\examples{
tab = matrix(c(1000, 20, 20, 400), ncol = 2)
dicer(tab)
}
