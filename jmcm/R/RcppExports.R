# This file was generated by Rcpp::compileAttributes
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#'@title Fit Joint Mean-Covariance Models based on MCD
#'@description Fit joint mean-covariance models based on MCD.
#'@param m an integer vector of numbers of measurements for subject.
#'@param Y a vector of responses for all subjects.
#'@param X model matrix for the mean structure model.
#'@param Z model matrix for the diagonal matrix.
#'@param W model matrix for the lower triangular matrix.
#'@param start starting values for the parameters in the model.
#'@param trace the values of the objective function and the parameters are printed for all the trace'th iterations.
#'@param profile whether parameters should be estimated sequentially using the idea of profile likelihood or not.
#'@param errorMsg whether or not the error message should be print.
#'@seealso \code{\link{acd_estimation}} for joint mean covariance model fitting based on ACD,
#' \code{\link{hpc_estimation}} for joint mean covariance model fitting based on HPC.
#'@export
mcd_estimation <- function(m, Y, X, Z, W, start, trace = FALSE, profile = TRUE, errorMsg = FALSE) {
    .Call('jmcm_mcd_estimation', PACKAGE = 'jmcm', m, Y, X, Z, W, start, trace, profile, errorMsg)
}

#'@title Fit Joint Mean-Covariance Models based on ACD
#'@description Fit joint mean-covariance models based on ACD.
#'@param m an integer vector of numbers of measurements for subject.
#'@param Y a vector of responses for all subjects.
#'@param X model matrix for the mean structure model.
#'@param Z model matrix for the diagonal matrix.
#'@param W model matrix for the lower triangular matrix.
#'@param start starting values for the parameters in the model.
#'@param trace the values of the objective function and the parameters are printed for all the trace'th iterations.
#'@param profile whether parameters should be estimated sequentially using the idea of profile likelihood or not.
#'@param errorMsg whether or not the error message should be print.
#'@seealso \code{\link{mcd_estimation}} for joint mean covariance model fitting based on MCD,
#' \code{\link{hpc_estimation}} for joint mean covariance model fitting based on HPC.
#'@export
acd_estimation <- function(m, Y, X, Z, W, start, trace = FALSE, profile = TRUE, errorMsg = FALSE) {
    .Call('jmcm_acd_estimation', PACKAGE = 'jmcm', m, Y, X, Z, W, start, trace, profile, errorMsg)
}

#'@title Fit Joint Mean-Covariance Models based on HPC
#'@description Fit joint mean-covariance models based on HPC.
#'@param m an integer vector of numbers of measurements for subject.
#'@param Y a vector of responses for all subjects.
#'@param X model matrix for the mean structure model.
#'@param Z model matrix for the diagonal matrix.
#'@param W model matrix for the lower triangular matrix.
#'@param start starting values for the parameters in the model.
#'@param trace the values of the objective function and the parameters are printed for all the trace'th iterations.
#'@param profile whether parameters should be estimated sequentially using the idea of profile likelihood or not.
#'@param errorMsg whether or not the error message should be print.
#'@seealso \code{\link{mcd_estimation}} for joint mean covariance model fitting based on MCD,
#' \code{\link{acd_estimation}} for joint mean covariance model fitting based on ACD.
#'@export
hpc_estimation <- function(m, Y, X, Z, W, start, trace = FALSE, profile = TRUE, errorMsg = FALSE) {
    .Call('jmcm_hpc_estimation', PACKAGE = 'jmcm', m, Y, X, Z, W, start, trace, profile, errorMsg)
}

