if (!require("future")) install.packages("future")

library(shiny)
library(plumber)
library(httr)

# UI Definition
ui <- fluidPage(
  
  # Application title
  titlePanel("API Wrapper with Data Visualization"),
  
  
      # API status display
      verbatimTextOutput("api_status")
    )
# Server Logic
server <- function(input, output) {
  
  # API status indicator
  output$status <- renderPrint({
    "API is running in the background. Access API endpoints at /__docs__/"
  })
  
  # Start API when app launches (in a separate process)
  observe({
    # Start Plumber API in background
    future::future({
      pr <- plumb("plumber.R")
      pr$run(host = '0.0.0.0', port = 8080)
    })
  })
}

# Run the application with explicit UI/Server call
shinyApp(ui = ui, server = server)