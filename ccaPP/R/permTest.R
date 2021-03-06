# ----------------------
# Author: Andreas Alfons
#         KU Leuven
# ----------------------

#' (Robust) permutation test for no association
#' 
#' Test whether or not there is association betwenn two data sets, with a focus 
#' on robust and nonparametric correlation measures.
#' 
#' The test generates \code{R} data sets by randomly permuting the observations 
#' of \code{x}, while keeping the observations of \code{y} fixed.  In each 
#' replication, a function to compute a maximum correlation measure is 
#' applied to the permuted data sets.  The \eqn{p}-value of the test is then 
#' given by the percentage of replicates of the maximum correlation measure 
#' that are larger than the maximum correlation measure computed from the 
#' original data.
#' 
#' @param x,y  each can be a numeric vector, matrix or data frame.
#' @param R  an integer giving the number of random permutations to be used.
#' @param fun  a function to compute a maximum correlation measure between 
#' two data sets, e.g., \code{\link{maxCorGrid}} (the default) or 
#' \code{\link{maxCorProj}}.  It should expect the data to be passed as the 
#' first and second argument, and must return an object of class 
#' \code{"maxCor"}.
#' @param permutations  an integer matrix in which each column contains the 
#' indices of a permutation.  If supplied, this is preferred over \code{R}.
#' @param nCores  a positive integer giving the number of processor cores to be 
#' used for parallel computing (the default is 1 for no parallelization).  If 
#' this is set to \code{NA}, all available processor cores are used.
#' @param cl  a \pkg{parallel} cluster for parallel computing as generated by 
#' \code{\link[parallel]{makeCluster}}.  If supplied, this is preferred over 
#' \code{nCores}.
#' @param seed  optional integer giving the initial seed for the random number 
#' generator (see \code{\link{.Random.seed}}).  For parallel computing, random 
#' number streams are used rather than the standard random number generator and 
#' the seed is set via \code{\link{clusterSetRNGStream}}.
#' @param \dots  additional arguments to be passed to \code{fun}.
#' 
#' @returnClass permTest
#' @returnItem pValue  the \eqn{p}-value for the test.
#' @returnItem cor0  the value of the test statistic.
#' @returnItem cor  the values of the test statistic for each of the permutated 
#' data sets.
#' @returnItem R  the number of random permutations.
#' @returnItem seed  the seed of the random number generator.
#' @returnItem call  the matched function call.
#' 
#' @author Andreas Alfons
#' 
#' @seealso \code{\link{maxCorGrid}}, \code{\link{maxCorProj}}
#' 
#' @references 
#' A. Alfons, C. Croux and P. Filzmoser (2016) Robust maximum association 
#' between data sets: The \R Package \pkg{ccaPP}.  \emph{Austrian Journal of 
#' Statistics}, \bold{45}(1), 71--79.
#' 
#' @examples 
#' data("diabetes")
#' x <- diabetes$x
#' y <- diabetes$y
#' 
#' ## Spearman correlation
#' permTest(x, y, R = 100, method = "spearman")
#' permTest(x, y, R = 100, method = "spearman", consistent = TRUE)
#' 
#' ## Pearson correlation
#' permTest(x, y, R = 100, method = "pearson")
#' 
#' @keywords multivariate robust
#' 
#' @importFrom stats runif
#' @import parallel
#' @export

permTest <- function(x, y, R = 1000, fun = maxCorGrid, permutations = NULL, 
                     nCores = 1, cl = NULL, seed = NULL, ...) {
  ## initializations
  matchedCall <- match.call()
  x <- as.matrix(x)
  y <- as.matrix(y)
  n <- nrow(x)
  if(nrow(y) != n) {
    stop("'x' and 'y' must have the same number of observations")
  }
  if(is.null(permutations)) {
    R <- rep(as.integer(R), length.out=1)
    if(is.na(R) || R < 1) R <- formals()$R    
  } else {
    permutations <- as.matrix(permutations)
    if(nrow(permutations) != n) {
      stop(sprintf("'permutations' must have %d rows", n))
    }
    R <- ncol(permutations)
    if(R == 0) stop("no permutations")
  }
  # set up parallel computing if requested
  haveCl <- inherits(cl, "cluster")
  if(haveCl) haveNCores <- FALSE
  else {
    if(is.na(nCores)) nCores <- detectCores()  # use all available cores
    if(!is.numeric(nCores) || is.infinite(nCores) || nCores < 1) {
      nCores <- 1  # use default value
      warning("invalid value of 'nCores'; using default value")
    } else nCores <- as.integer(nCores)
    nCores <- min(nCores, R)
    haveNCores <- nCores > 1
  }
  # check whether parallel computing should be used
  useParallel <- haveNCores || haveCl
  # set up multicore or snow cluster if not supplied
  if(haveNCores) {
    if(.Platform$OS.type == "windows") {
      cl <- makePSOCKcluster(rep.int("localhost", nCores))
    } else cl <- makeForkCluster(nCores)
    on.exit(stopCluster(cl))
  }
  # set seed of random number generator
  if(useParallel) {
    # set seed of the random number stream
    if(!is.null(seed)) clusterSetRNGStream(cl, iseed=seed)
    else if(haveNCores) clusterSetRNGStream(cl)
  } else {
    # check or set seed of the random number generator
    if(is.null(seed)) {
      if(!exists(".Random.seed", envir=.GlobalEnv, inherits=FALSE)) {
        runif(1)
      }
      seed <- .Random.seed
    } else set.seed(seed)  # set seed for reproducibility
  }
  ## define function call to compute maximum correlation
  dots <- list(...)
  if(length(dots) == 0) {
    call <- as.call(list(fun))
    call[[2]] <- x
    call[[3]] <- y
  } else {
    call <- as.call(c(list(fun, x, y), dots))
  }
  ## compute maximum correlation and bootstrap replicates
  ## in the bootstrap replicates, permute rows of x and compute maximum 
  ## correlation with y
  if(useParallel) {
    if(is.null(permutations)) {
      r <- parSapply(cl, 0:R, function(r) {
        if(r > 0) call[[2]] <- x[sample.int(n), , drop=FALSE]
        rep(eval(call)$cor, length.out=1)
      })
    } else {
      r <- parSapply(cl, 0:R, function(r, p) {
        if(r > 0) call[[2]] <- x[p[, r], , drop=FALSE]
        rep(eval(call)$cor, length.out=1)
      }, permutations)
    }
    r0 <- r[1]  # extract maximum correlation with original data
    r <- r[-1]  # remaining elements are the bootstrap replicates
  } else {
    # compute maximum correlation with original data
    r0 <- rep(eval(call)$cor, length.out=1)
    # compute bootstrap replicates
    if(is.null(permutations)) {
      r <- replicate(R, {
        call[[2]] <- x[sample.int(n), , drop=FALSE]
        rep(eval(call)$cor, length.out=1)
      })
    } else {
      r <- sapply(seq_len(R), function(r, p) {
        call[[2]] <- x[p[, r], , drop=FALSE]
        rep(eval(call)$cor, length.out=1)
      }, permutations)
    }
  }
  ## compute p-value
  pValue <- mean(r > r0)
  ## return results
  out <- list(pValue=pValue, cor0=r0, cor=r, R=R, seed=seed, call=matchedCall)
  class(out) <- "permTest"
  out
}
