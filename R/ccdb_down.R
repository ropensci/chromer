# taken from https://stackoverflow.com/a/60627969
ccdb_down <- function(url_in="http://ccdb.tau.ac.il",timeout=2){
  con <- url(url_in)
  check <- suppressWarnings(try(open.connection(con,open="rt",timeout=timeout),silent=TRUE)[1])
  suppressWarnings(try(close.connection(con),silent=TRUE))
  ifelse(is.null(check),FALSE,TRUE)
}
