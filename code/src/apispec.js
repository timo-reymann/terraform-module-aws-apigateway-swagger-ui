const apiSpecFileName = process.env.SWAGGER_SPEC_FILE || "openapi.yaml"
const apiSpecFileContent = require("internal-apigateway-swagger")(apiSpecFileName)
const apiSpecParer = apiSpecFileName.endsWith("json") ? JSON.parse : require('yamljs').parse
const apiSpecDocument = apiSpecParer(apiSpecFileContent)

const removeXProperties = (definition) => Object.keys(definition).forEach(key => {
    const nestedProperty = definition[key];
    if (key.startsWith("x-")) {
        delete definition[key]
    } else if (typeof nestedProperty === 'object') {
        removeXProperties(nestedProperty);
    }
})

removeXProperties(apiSpecDocument)

module.exports =  apiSpecDocument
