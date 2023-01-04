const handler = require("../dist/main").handler;

describe("Bundled handler", () => {
    it("should work for swagger ui index", async () => {
        const result = await handler({
            "resource": "/swagger-ui/",
            "path": "/swagger-ui/",
            "httpMethod": "GET",
            "queryStringParameters": null,
            "multiValueQueryStringParameters": null,
            "pathParameters": null,
            "stageVariables": null,
            "body": null,
            "isBase64Encoded": false
        }, null)

        expect(result).toHaveProperty("body")
        expect(result.body.length).toBeGreaterThan(1000)

        expect(result).toHaveProperty("statusCode")
        expect(result.statusCode).toBe(200)

        expect(result).toHaveProperty("headers")
        expect(result.headers['content-type']).toBe("text/html; charset=utf-8")
    })

    it("should serve the css", async () => {
        const result = await handler({
            "resource": "/swagger-ui/swagger-ui.css",
            "path": "/swagger-ui/swagger-ui.css",
            "httpMethod": "GET",
            "queryStringParameters": null,
            "multiValueQueryStringParameters": null,
            "pathParameters": null,
            "stageVariables": null,
            "body": null,
            "isBase64Encoded": false
        }, null)

        expect(result.statusCode).toBe(200)
        expect(result.headers['content-type']).toBe("text/css; charset=UTF-8")
    })
})
