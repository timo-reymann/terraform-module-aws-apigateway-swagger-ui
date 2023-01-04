const express = require('express')
const swaggerUI = require('swagger-ui-express')

// Path configuration
const pathConfig = {
    uiPath: process.env.SWAGGER_UI_PATH || "/swagger-ui",
    entrypoint: {
        enabled: process.env.SWAGGER_UI_ENTRYPOINT_ENABLED || true,
        path: process.env.SWAGGER_UI_ENTRYPOINT || "/swagger-ui.html"
    }
}

// API Spec loading
const apiSpecFileName = process.env.SWAGGER_SPEC_FILE || "openapi.yaml"
const apiSpecFileContent = require("internal-apigateway-swagger")(apiSpecFileName)
const apiSpecParer = apiSpecFileName.endsWith("json") ? JSON.parse : require('yamljs').parse
const apiSpecDocument = apiSpecParer(apiSpecFileContent)

// Create express app
const app = express()
app.use(
    pathConfig.uiPath,
    swaggerUI.serve,
    swaggerUI.setup(apiSpecDocument, {
        swaggerOptions: {
            explorer: true,
        }
    })
)

// redirect request from entrypoint to nested swagger ui path
if (pathConfig.entrypoint.enabled) {
    app.get(pathConfig.entrypoint.path, (req, res) => {
        res.redirect(302, `${pathConfig.uiPath}`)
        return res;
    })
}

// Expose express app
module.exports = app
