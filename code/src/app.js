const express = require('express')
const swaggerUI = require('swagger-ui-express')

const pathConfig = {
    uiPath: process.env.SWAGGER_UI_PATH || "/swagger-ui",
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

// redirect request from entrypoint to nested swagger ui path
if (pathConfig.entrypoint.enabled) {
    app.get(pathConfig.entrypoint.path, (req, res) => {
        res.redirect(302, `${pathConfig.uiPath}`)
        return res;
    })
}

// Expose express app
module.exports = app
