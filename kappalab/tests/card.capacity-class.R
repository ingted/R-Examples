library(kappalab)

x <- runif(8)
for (i in 2:8)
    x[i] <- x[i] + x[i-1]
mu <- card.capacity(c(0,x))
stopifnot(abs(conjugate(conjugate(mu))@data - mu@data) < 1e-6)
stopifnot(abs(mu@data - zeta(Mobius(mu))@data) < 1e-6)
stopifnot(abs(normalize(normalize(mu))@data - normalize(mu)@data) < 1e-6)

mu2 <- as.capacity(mu)
a <- Mobius(mu2)
stopifnot(abs(mu@data - as.card.capacity(mu2)@data) < 1e-6)
stopifnot(abs(a@data - Mobius(zeta(a))@data) < 1e-6)
stopifnot(abs(veto(mu) - veto(a)) < 1e-6)
stopifnot(abs(favor(mu) - favor(a)) < 1e-6)
stopifnot(abs(orness(mu) - orness(a)) < 1e-6)
stopifnot(abs(variance(mu) - variance(a)) < 1e-6)
stopifnot(abs(entropy(mu) - entropy(a)) < 1e-6)
stopifnot(abs(veto(mu2) - veto(a)) < 1e-6)
stopifnot(abs(favor(mu2) - favor(a)) < 1e-6)
stopifnot(abs(orness(mu2) - orness(a)) < 1e-6)
stopifnot(abs(variance(mu2) - variance(a)) < 1e-6)
stopifnot(abs(entropy(mu2) - entropy(a)) < 1e-6)
