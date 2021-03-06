##' @title Pluck tbl's by name from a foieGras fitted model object
##'
##' @description `pluck()` lets you obtain `fitted`, `predicted`, or `data` tbl's from
##' a compound tbl created when fitting to multiple individual data sets. The specified tbl's
##' are appended to a single output tbl.
##'
##' @usage pluck(fitobj, what)
##'
##' @param fitobj a foieGras fitted model object
##' @param what the tbl to be plucked; either `fitted`, `predicted`, or `data` (single letters can be used)
##'
##' @return a tbl with all individual tbl's appended
##'
##' @examples
##' \dontrun{
##' data("ellie")
##' ellie.fit <- fit_ssm(ellie, model = "crw", time.step = 6)
##'
##' pred <- pluck(ellie.fit, "predicted")
##' }
##' @importFrom dplyr %>% tbl_df arrange mutate select
##' @importFrom tibble as_tibble
##' @export
pluck <- function(x, what = "fitted", ...) {
  if (length(list(...)) > 0) {
    warning("additional arguments ignored")
  }
  what <- match.arg(what, choices = c("fitted","predicted","data"))

  if(!what %in% c("fitted","predicted","data"))
    stop("Only `fitted`, `predicted` or `data` objects can be extracted")

  ## remove convergence failures from extraction
  nf <- which(sapply(x$ssm, length) < 12)
  if(length(nf) > 0) {
    sprintf("%d convergence failures removed from output", length(nf))
    sprintf("ids: %s", x[nf, "id"])
    x <- x[-nf, ]
  }

  switch(what,
         fitted = {
           f <- lapply(x$ssm, function(.) .$fitted) %>%
             do.call(rbind, .) %>%
             as_tibble() %>%
             arrange(id)
           f <- switch(x$ssm[[1]]$pm,
                  rw = {
                    f %>% select(id, date, lon, lat, x, y, x.se, y.se)
                  },
                  crw = {
                    f %>% select(id, date, lat, lon, x, y, x.se, y.se, u, v, u.se, v.se)
                  })
           return(f)
         },
         predicted = {
           p <- lapply(x$ssm, function(.) .$predicted) %>%
             do.call(rbind, .) %>%
             as_tibble() %>%
             arrange(id)
           p <- switch(x$ssm[[1]]$pm,
                       rw = {
                         p %>% select(id, date, lon, lat, x, y, x.se, y.se)
                       },
                       crw = {
                         p %>% select(id, date, lat, lon, x, y, x.se, y.se, u, v, u.se, v.se)
                       })
           return(p)
         },
         data = {
           lapply(x$ssm, function(.) .$data) %>%
             do.call(rbind, .) %>%
             as_tibble() %>%
             arrange(id)
         })

}
