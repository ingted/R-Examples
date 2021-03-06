"summary.RSmplext" <-
function(object,...)
{
  cat("\nStatus of extracted object ",deparse(substitute(object)),":\n", sep="")
  cat("\tn =",object$n,"\n")
  cat("\tk =",object$k,"\n")
  cat("\tburn_in =",object$burn_in,"\n")
  cat("\tn_eff =",object$n_eff,"\n")
  cat("\tstep =",object$step,"\n")
  cat("\tseed =",object$seed,"\n")
  cat("\ttfixed =",object$tfixed,"\n")
  cat("\tn_tot =",object$n_tot,"\n")
  cat("\toutvec contains",length(object$outvec),"elements\n\n")
}
