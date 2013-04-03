\name{anotherBkp}
\alias{anotherBkp}
\title{Get best candidate change point}
\description{Get best candidate change point according to binary segmentation}
\usage{anotherBkp(Y, weightFUN = defaultWeights, verbose = FALSE)}
\arguments{
  \item{Y}{A \code{n*p} matrix, \code{p} signals of length \code{n} to be
segmented (centered by column)}
  \item{weightFUN}{A \code{function} returning a \code{(n-1)*1} vector of weights for
the candidate change point positions. Default weights yield the
likelihood ratio test (LRT) statistic for the identification of a
single change point.}
  \item{verbose}{A \code{logical} value: should extra information be output ? Defaults to \code{FALSE}.}
}
\details{Contrary to \code{oneBkp}, \code{anotherBkp} handles missing values (NA:s).}


\author{Morgane Pierre-Jean and Pierre Neuvial}




\examples{
p <- 2
n <- 100

sim <- jointSeg:::randomProfile(n, 1, 1, p)
Y <- sim$profile
bkp <- jointSeg:::anotherBkp(Y)
print(bkp)
print(jointSeg:::oneBkp(Y))
##  stopifnot(identical(jointSeg:::oneBkp(Y), bkp))
par(mfrow=c(p,1))
for (ii in 1:p) {
  plot(Y[, ii], pch=19, cex=0.2)
  abline(v=bkp+0.5, col=3)
  abline(v=sim$bkp+0.5, col=8, lty=2)
}

## robustness to NA:s
h <- 2
idxs <- seq(from=max(sim$bkp[1]-h, 1),min(sim$bkp[1]+h, n))
Y[idxs, p] <- NA
jointSeg:::oneBkp(Y)  ## does not work
bkp <- jointSeg:::anotherBkp(Y)  ## works
bkp-sim$bkp
}

\keyword{internal}