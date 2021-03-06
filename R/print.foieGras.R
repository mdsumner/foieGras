##' Print \code{ctrw}
##'
##' @method print foieGras
##'
##' @param x a \code{ctrw} fit object
##' @param digits number of digits to use in display
##' @param ... unused. For compatibility with the generic method.
##'
##' @export

print.foieGras <- function(x, digits = 3, ...)
{
  pm <- x$pm
  timeStep <- mean(diff(x$predicted$date))
  nbrStates <- nrow(x$predicted)
  nbStates <- nrow(x$fitted)
  parm <- x$par

  cat("Process model:", pm, "\n")
  cat("Time interval:", timeStep, "hours \n")
  cat("number of observations:", nbStates, "\n")
  cat("number of regularised state estimates:", nbrStates, "\n\n")
  cat("parameter estimates\n")
  cat("-------------------\n")
  print(parm, digits = digits, justify = "right")
  cat("-------------------\n")
  cat("negative log-likelihood:", x$opt$objective, "\n")
  cat("convergence:", x$opt$message, "\n\n")

}
