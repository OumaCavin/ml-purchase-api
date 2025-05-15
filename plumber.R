# purchase_api.R
# Customer Purchase Prediction API using Plumber
# plumber::plumb("plumber.R")$run(port = 8000) or  plumb(file='plumber.R')$run() # Test the API locally with:

# Load required libraries
library(plumber)
library(caret)

# Load all trained models and preprocessing
logit_model <- readRDS("models/logit_model.rds")
tree_model <- readRDS("models/tree_model.rds")
preprocessor <- readRDS("models/preprocessing.rds")  # From your scaling step

#* @apiTitle Customer Purchase Prediction API
#* @apiDescription Predicts purchase probability using either logistic regression or decision tree.

#* Log all requests - incoming request data
#* @filter logger
function(req) {
  cat(
    "Time:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n",
    "Request:", req$REQUEST_METHOD, req$PATH_INFO, "\n",
    "User Agent:", req$HTTP_USER_AGENT, "\n",
    "IP:", req$REMOTE_ADDR, "\n\n",
    sep = " "
  )
  plumber::forward()
}

#* Predict purchase probability
#* @param Age numeric: Customer age (18-100)
#* @param Gender character: "Male" or "Female"
#* @param EstimatedSalary numeric: Monthly salary
#* @param model_type character: "logistic" or "tree" (default: "logistic")
#* @post /predict
function(Age, Gender, EstimatedSalary, model_type = "logistic") {
  
  # Convert inputs to correct types
  Age <- as.numeric(Age)
  EstimatedSalary <- as.numeric(EstimatedSalary)
  Gender <- as.character(Gender)
  model_type <- as.character(model_type)
  
  # Input validation
  tryCatch({
    if (is.na(Age)) stop("Age must be a number")
    if (is.na(EstimatedSalary)) stop("Salary must be a number")
    if (Age < 18 || Age > 100) stop("Age must be between 18 and 100")
    if (EstimatedSalary < 0) stop("Salary must be positive")
    if (!Gender %in% c("Male", "Female")) stop("Gender must be 'Male' or 'Female'")
    if (!model_type %in% c("logistic", "tree")) stop("Model type must be 'logistic' or 'tree'")
    
    # Prepare data frame (match training format)
    new_data <- data.frame(
      Age = Age,
      Gender = factor(Gender, levels = c("Female", "Male")),  # Maintain factor levels
      EstimatedSalary = EstimatedSalary
    )
    
    # Apply preprocessing
    new_data[, c("Age", "EstimatedSalary")] <- predict(preprocessor, new_data[, c("Age", "EstimatedSalary")])
    
    # Make prediction
    if (model_type == "logistic") {
      prob <- predict(logit_model, newdata = new_data, type = "response")
    } else {
      prob <- predict(tree_model, newdata = new_data, type = "prob")[, "1"]
    }
    
    # Return formatted response
    list(
      success = TRUE,
      probability = round(prob, 4),
      prediction = ifelse(prob > 0.5, "Likely to purchase", "Unlikely to purchase"),
      decision_boundary = 0.5,
      model_used = model_type,
      model_version = "1.1"
    )
  }, error = function(e) {
    list(
      success = FALSE,
      error = conditionMessage(e),
      timestamp = Sys.time()
    )
  })
}

#* Health check endpoint
#* @get /health
function() {
  list(
    status = "OK",
    time = Sys.time(),
    models_loaded = c("logistic", "decision_tree"),
    model_version = "1.1"
  )
}

#* Model information endpoint
#* @get /model-info
function() {
# Return structured error response 
  list(
    logistic_model = summary(logit_model)$call,
    tree_model = tree_model$method,
    preprocessing = summary(preprocessor)$method,
    last_updated = file.info("models/logit_model.rds")$mtime
  )
}