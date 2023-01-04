const apiSpecFileName = process.env.SWAGGER_SPEC_FILE || "openapi.yaml"
const apiSpecFileContent = require("internal-apigateway-swagger")(apiSpecFileName)
const apiSpecParer = apiSpecFileName.endsWith("json") ? JSON.parse : require('yamljs').parse
const apiSpecDocument = apiSpecParer(apiSpecFileContent)

module.exports = apiSpecDocument
