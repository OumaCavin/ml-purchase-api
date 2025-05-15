library(plumber)
pr <- plumb("plumber.R")
pr$run(host = '0.0.0.0', port = as.numeric(Sys.getenv("PORT")))