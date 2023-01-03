const express = require('express')
const serverless = require('serverless-http')
const swaggerUI = require('swagger-ui-express')

const app = express()
const path = process.env.SWAGGER_UI_PATH || "/swagger-ui"
const swaggerUiEntrypoint = process.env.SWAGGER_UI_ENTRYPOINT || "/swagger-ui.html"
const swaggerUiEntrypointEnabled = process.env.SWAGGER_UI_ENTRYPOINT_ENABLED || true
const apiSpecFileName = process.env.SWAGGER_SPEC_FILE || "openapi.yaml"

const apiSpecFileContent = require("internal-apigateway-swagger")(apiSpecFileName)
let apiSpec = null

if(apiSpecFileName.endsWith("json")) {
  apiSpec = JSON.parse(apiSpecFileContent)
} else {
  const YAML = require('yamljs')
  apiSpec = YAML.parse(apiSpecFileContent)
}

console.log(apiSpec)
app.use(
  path,
  swaggerUI.serve,
  swaggerUI.setup(apiSpec, {
    swaggerOptions: {
      explorer: true,
    }
  })
)

// redirect request from entrypoint to nested swagger ui path
if (swaggerUiEntrypointEnabled) {
  app.get(swaggerUiEntrypoint, (req, res) => {
    console.log("Redirect to swagger ui")
    res.redirect(302, `.${path}`)
    return res;
  })
}

module.exports.handler = serverless(app)
