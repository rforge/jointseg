\name{PSSeg}
\alias{PSSeg}
\title{Parent-Specific copy number segmentation}
\description{This function splits (bivariate) copy number signals into
parent-specific (PS) segments using recursive binary segmentation}
\usage{PSSeg(data, method, stat = NULL, dropOutliers = TRUE, rankTransform = FALSE, 
    ..., profile = FALSE, verbose = FALSE)}
\arguments{
  \item{data}{Data frame containing the following columns: \describe{
\item{c:}{Total copy number (logged or non-logged)}
\item{b:}{Allele B fraction}
\item{genotype:}{(germline) genotype of the SNP, coded as 0 for AA, 1/2 for AB, 1 for BB}
}
These data are assumed to be ordered by genome position.}
  \item{method}{\describe{
\item{"RBS"}{Recursive Binary Segmentation, see
\code{\link{doRBS}}}
\item{"GFLars"}{Group fused LARS as described in Bleakley and
Vert (2011).}
\item{"DP"}{Univariate pruned dynamic programming Rigaill et al (2010) or bivariate dynamic programming}
\item{"PSCBS"}{Parent-specific copy number in paired tumor-normal studies using circular binary segmentation by Olshen A. et al
(2011)}
\item{"other"}{The segmentation method is passed as a function using argument \code{segFUN} (see examples in directory \code{otherMethods}).}
}}
  \item{stat}{A vector containing the names or indices of the columns of \code{Y} to be segmented}
  \item{dropOutliers}{If TRUE, outliers are droped by using DNAcopy package}
  \item{rankTransform}{If TRUE, data are replaced by their ranks before segmentation}
  \item{\dots}{Further arguments to be passed to \code{jointSeg}}
  \item{profile}{Trace time and memory usage ?}
  \item{verbose}{A \code{logical} value: should extra information be output ? Defaults to \code{FALSE}.}
}
\details{Before segmentation, the decrease in heterozygosity
\code{d=2|b-1/2|} defined in Bengtsson et al, 2010 is calculated
from the input data.  \code{d} is only defined for heterozygous
SNPs, that is, SNPs for which \code{data$genotype==1/2}. \code{d}
may be seen as a "mirrored" version of allelic ratios (\code{b}):
it converts them to a piecewise-constant signals by taking
advantage of the bimodality of \code{b} for heterozygous SNPs.
The rationale for this transformation is that allelic ratios
(\code{b}) are only informative for heterozygous SNPs (see
e.g. Staaf et al, 2008).

Before segmentation, the outliers in the copy number signal are
droped according the method explained by
Venkatraman, E. S. and Olshen, A. B., 2007.

The resulting data are then segmented using the
\code{\link{jointSeg}} function, which combines an initial
segmentation according to argument \code{method} and pruning of
candidate change points by dynamic programming (skipped when the
initial segmentation *is* dynamic programming).

If argument \code{stat} is not provided, then dynamic
programming is run on the two dimensional statistic
\code{"(c,d)"}.

If argument \code{stat} is provided, then dynamic
programming is run on \code{stat}; in this case we implicitly
assume that \code{stat} is a piecewise-constant signal.}

\references{Bengtsson, H., Neuvial, P., & Speed,
T. P. (2010). TumorBoost: Normalization of allele-specific tumor
copy numbers from a single pair of tumor-normal genotyping
microarrays. BMC bioinformatics, 11(1), 245.

Staaf, J., Lindgren, D., Vallon-Christersson, J.,
Isaksson, A., Goransson, H., Juliusson, G., ... & Ringn\'er,
M. (2008). Segmentation-based detection of allelic imbalance and
loss-of-heterozygosity in cancer cells using whole genome SNP
arrays. Genome Biol, 9(9), R136.}
\author{Morgane Pierre-Jean and Pierre Neuvial}



\seealso{\code{\link{jointSeg}}}
\examples{
## load known real copy number regions
affyDat <- loadCnRegionData(dataSet="GSE29172", tumorFraction=0.5)

## generate a synthetic CN profile
K <- 10
len <- 1e4
sim <- getCopyNumberDataByResampling(len, K, regData=affyDat)
datS <- sim$profile

## run binary segmentation (+ dynamic programming) resRBS <-
resRBS <- PSSeg(data=datS, method="RBS", stat=c("c", "d"), K=2*K, profile=TRUE)
resRBS$prof

getTpFp(resRBS$bestBkp, sim$bkp, tol=5)
plotSeg(datS, breakpoints=list(sim$bkp, resRBS$bestBkp))
}
