# This file was generated by Rcpp::compileAttributes
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

eloint <- function(winner, loser, allids, kval, startvalues, runs) {
    .Call('EloChoice_eloint', PACKAGE = 'EloChoice', winner, loser, allids, kval, startvalues, runs)
}

elointnorm <- function(winner, loser, allids, kval, startvalues, runs) {
    .Call('EloChoice_elointnorm', PACKAGE = 'EloChoice', winner, loser, allids, kval, startvalues, runs)
}

