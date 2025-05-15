# Load required packages
if (!require("plumber")) install.packages("plumber", repos="https://cloud.r-project.org")
library(plumber)

# Load API
pr <- plumb("plumber.R")
port <- as.numeric(Sys.getenv("PORT", unset = 8080))

# Run with error handling
tryCatch({
  pr$run(host = "0.0.0.0", port = port)
}, error = function(e) {
  message("Failed to start plumber: ", e$message)
  # List installed packages for debugging
  message("Installed packages: ", paste(installed.packages()[,1], collapse=", "))
})