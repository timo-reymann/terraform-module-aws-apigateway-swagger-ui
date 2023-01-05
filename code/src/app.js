const express = require('express')
const swaggerUI = require('swagger-ui-express')

const pathConfig = {
    uiPath: process.env.SWAGGER_UI_PATH || "/swagger-ui",
    config: {
        enabled: process.env.SWAGGER_CONFIG_ENDPOINT_ENABLED || true,
        path: process.env.SWAGGER_CONFIG_ENDPOINT_PATH || "/swagger-config",
    },
    entrypoint: {
        enabled: process.env.SWAGGER_UI_ENTRYPOINT_ENABLED || true,
        path: process.env.SWAGGER_UI_ENTRYPOINT || "/swagger-ui.html"
    }
}
const apiSpecDocument = require("./apispec.js")

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

// enable swagger config endpoint
if (pathConfig.config.enabled) {
    app.get(pathConfig.config.path, (req, res) => {
        res.json(apiSpecDocument)
    })
}

// redirect request from entrypoint to nested swagger ui path
if (pathConfig.entrypoint.enabled) {
    app.get(pathConfig.entrypoint.path, (req, res) => {
        res.redirect(302, `${pathConfig.uiPath}`)
    })
}

// Expose express app
module.exports = app
