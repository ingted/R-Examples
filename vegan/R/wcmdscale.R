`wcmdscale` <-
function(d, k, eig = FALSE, add = FALSE, x.ret = FALSE, w)
{
    weight.centre <- function(x, w) {
        w.c <- apply(x, 2, weighted.mean, w = w)
        x <- sweep(x, 2, w.c, "-")
        x
    }
    if (add)
        .NotYetUsed("add")
    ## Force eig=TRUE if add, x.ret or !missing(w)
    if(x.ret)
        eig <- TRUE
    ZERO <- sqrt(.Machine$double.eps)
    if (!inherits(d, "dist")) {
        op <- options(warn = 2)
        on.exit(options(op))
        d <- as.dist(d)
        options(op)
    }
    m <- as.matrix(d^2)
    n <- nrow(m)
    if (missing(w))
        w <- rep(1, n)
    m <- weight.centre(m, w)
    m <- t(weight.centre(t(m), w))
    m <- m * sqrt(w) %o% sqrt(w)
    e <- eigen(-m/2, symmetric = TRUE)
    ## Remove zero eigenvalues, keep negative
    keep <- abs(e$values) > ZERO
    e$values <- e$values[keep]
    e$vectors <- e$vectors[, keep, drop = FALSE]
    ## Deweight and scale axes -- also negative
    points <- sweep(e$vectors, 1, sqrt(w), "/")
    points <- sweep(points, 2, sqrt(abs(e$values)), "*")
    rownames(points) <- rownames(m)
    ## If 'k' not given, find it as the number of positive
    ## eigenvalues, and also save negative eigenvalues
    negaxes <- NULL
    if (missing(k) || k > sum(e$value > ZERO)) {
        k <- sum(e$values > ZERO)
        if (any(e$values < 0))
            negaxes <- points[, e$values < 0, drop = FALSE]
    }
    points <- points[, 1:k, drop=FALSE]
    points[!is.finite(points)] <- NA
    ## Goodness of fit
    ev <- e$values[1:k]
    ev <- ev[ev > 0]
    ## GOF for real and all axes
    GOF <- c(sum(ev)/sum(abs(e$values)),
             sum(ev)/sum(e$values[e$values > 0]))
    if (eig || x.ret) {
        colnames(points) <- paste("Dim", seq_len(NCOL(points)), sep="") 
        out <- list(points = points, eig = if (eig) e$values,
                    x = if (x.ret) m, ac = NA, GOF = GOF, weights = w,
                    negaxes = negaxes, call = match.call())
        class(out) <- "wcmdscale"
    }
    else out <- points
    out
}
