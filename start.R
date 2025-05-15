# start.R
library(plumber)

# Load API
pr <- plumb("plumber.R")

# Configure
pr$setDocs(TRUE)$setDebug(TRUE)

# Run (Railway provides PORT automatically)
pr$run(
  host = "0.0.0.0",
  port = as.numeric(Sys.getenv("PORT")),
  swagger = TRUE
)