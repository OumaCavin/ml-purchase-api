library(plumber)

# Create Plumber router
pr <- plumb("plumber.R")

# Configure documentation and debugging
pr$setDocs(TRUE)  # Enable Swagger docs
pr$setDebug(TRUE)  # Enable debugging

# Get port from environment (works on ShinyApps.io)
port <- as.numeric(Sys.getenv('PORT', unset = 8080))

# Run the API
pr$run(
  host = '0.0.0.0', 
  port = port,
  swagger = TRUE  # Enable Swagger UI
)