#
# Convert a fmdat object to a data frame for ggplot2
#
fortify.fmdat <- function(model, ...) {
  # === Check package availability  ===
  .load_ggplot2()

  # === Validate input arguments ===
  .validate(model)

  # === Prepare a data frame for ggplot2 ===
  curve_df <- data.frame(x = model[["labels"]],
                         y = model[["ranks"]])
}

#
# Convert a cmats object to a data frame for ggplot2
#
fortify.cmats <- function(model, ...) {
  # === Check package availability  ===
  .load_ggplot2()

  # === Validate input arguments ===
  .validate(model)

  # === Prepare a data frame for ggplot2 ===
  n <- length(model[["ranks"]])
  curve_df <- data.frame(x = rep(1:length(model[["ranks"]]), 4),
                         y = c(model[["tp"]], model[["fn"]],
                               model[["fp"]], model[["tn"]]),
                         group = factor(c(rep("TPs", n), rep("FNs", n),
                                          rep("FPs", n), rep("TNs", n)),
                                        levels = c("TPs", "FNs",
                                                   "FPs", "TNs")))
}

#
# Convert a pevals object to a data frame for ggplot2
#
fortify.pevals <- function(model, ...) {
  # === Check package availability  ===
  .load_ggplot2()

  # === Validate input arguments ===
  .validate(model)

  # === Prepare a data frame for ggplot2 ===
  pb <- model[["basic"]]
  n <- length(pb[["error"]])
  curve_df <- data.frame(x = rep(1:n, 6),
                         y = c(pb[["error"]], pb[["accuracy"]],
                               pb[["specificity"]], pb[["sensitivity"]],
                               1 - pb[["specificity"]], pb[["precision"]]),
                         group = factor(c(rep("error", n),
                                          rep("accuracy", n),
                                          rep("specificity", n),
                                          rep("sensitivity", n),
                                          rep("1 - specificity", n),
                                          rep("precision", n)),
                                        levels = c("error", "accuracy",
                                                   "specificity",
                                                   "sensitivity",
                                                   "1 - specificity",
                                                   "precision")))
}

#' @rdname fortify
#' @export
fortify.sscurves <- function(model, raw_curves = TRUE, ...) {
  .fortify_common(model, raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.mscurves <- function(model, raw_curves = TRUE, ...) {
  .fortify_common(model, raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.smcurves <- function(model, raw_curves = FALSE, ...) {
  .fortify_common(model, raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.mmcurves <- function(model, raw_curves = FALSE, ...) {
  .fortify_common(model, raw_curves = raw_curves, ...)
}
#' @rdname fortify
#' @export
fortify.sspoints <- function(model, raw_curves = TRUE, ...) {
  .fortify_common(model, mode = "basic", raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.mspoints <- function(model, raw_curves = TRUE, ...) {
  .fortify_common(model, mode = "basic", raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.smpoints <- function(model, raw_curves = FALSE, ...) {
  .fortify_common(model, mode = "basic", raw_curves = raw_curves, ...)
}

#' @rdname fortify
#' @export
fortify.mmpoints <- function(model, raw_curves = FALSE, ...) {
  .fortify_common(model, mode = "basic", raw_curves = raw_curves, ...)
}
