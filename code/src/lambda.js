const serverless = require('serverless-http')
const app = require("./app.js")

// Wrap express app into serverless-http and set as handler
module.exports.handler = serverless(app)
