# ML Purchase Prediction API

![R](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![Plumber](https://img.shields.io/badge/Plumber-API-3679E5?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

![Swagger UI Preview](https://github.com/OumaCavin/ml-purchase-api/blob/main/images/swagger-preview.png?raw=true)  
*Interactive API documentation (Swagger UI)*

A machine learning API built with R's Plumber package to predict customer purchase behavior based on demographic and economic factors.

## Features

- 🚀 **RESTful endpoints** for purchase predictions
- 📊 **Swagger documentation** at `/__docs__/`
- 🤖 **Pre-trained models** included (logistic regression & decision tree)
- 📦 **Ready-to-deploy** on ShinyApps.io, Railway, or Docker

## API Endpoints

| Endpoint | Method | Parameters | Description |
|----------|--------|------------|-------------|
| `/predict` | POST | `Age`, `Gender`, `EstimatedSalary` | Returns purchase probability |
| `/health` | GET | - | Service status check |

## Quick Start

### Local Installation
```bash
git clone https://github.com/OumaCavin/ml-purchase-api.git
cd ml-purchase-api
```

### Run API Locally
```r
# Install dependencies
install.packages(c("plumber", "caret", "dplyr"))

# Start API (port 8080)
Rscript start.R
```
Access docs: http://localhost:8080/__docs__/

## Deployment

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template?template=plumber)
[![Deploy to ShinyApps.io](https://img.shields.io/badge/ShinyApps.io-Deploy-2c3e50?style=for-the-badge)](https://www.shinyapps.io/)

### Railway.app
```bash
# Set start command in Railway:
Rscript start.R
```

### ShinyApps.io
```r
rsconnect::deployApp(
  appDir = ".",
  appName = "ml-purchase-api",
  account = "oumacavin"
)
```

## Project Structure
```
ml-purchase-api/
├── plumber.R        # API endpoints
├── shiny_app.R          # Launch script
├── app.R            # Shiny wrapper (optional)
├── models/          # Pretrained models
│   ├── logit_model.rds
│   └── tree_model.rds
├── README.md        # This file
└── .gitignore
```

## Example Request
```bash
curl -X POST "https://oumacavin.shinyapps.io/purchase-prediction-api/predict" \
  -H "Content-Type: application/json" \
  -d '{"Age":35, "Gender":"Male", "EstimatedSalary":70000}'
```

## Dependencies
- R (≥ 4.0)
- plumber (≥ 1.0)
- caret (≥ 6.0)


## License
[MIT](LICENSE) © 2025 Cavin Otieno Ouma | [@OumaCavin](https://github.com/OumaCavin) | [![Twitter](https://img.shields.io/twitter/follow/kevingalacha?style=social)](https://twitter.com/kevingalacha)


