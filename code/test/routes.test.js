const app = require("../src/app.js");
const request = require("supertest");

describe("assets", () => {
    it("should load the icon", async () => {
        const res = await request(app)
            .get("/swagger-ui/favicon-16x16.png")
        expect(res.statusCode).toBe(200)
    })

    it("should load the entrypoint", async () => {
        const res = await request(app)
            .get("/swagger-ui/")
        expect(res.statusCode).toBe(200)
        expect(res.headers['content-type']).toBe("text/html; charset=utf-8")
    })

    it("should return 404 for other routes", async () => {
        const res = await request(app)
            .get("/")
        expect(res.statusCode).toBe(404)
    })
})
