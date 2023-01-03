const CopyWebpackPlugin = require("copy-webpack-plugin")

module.exports = {
    mode: "production",
    output: {
        libraryTarget: "commonjs",
    },
    optimization: {
        minimize: false,
    },
    performance: {
        hints: false,
    },
    //    mode: 'production',
    entry: './src/app.js',
    target: 'node',
    plugins: [
        new CopyWebpackPlugin({
            patterns: [
                './node_modules/swagger-ui-dist/swagger-ui.css',
                './node_modules/swagger-ui-dist/swagger-ui-bundle.js',
                './node_modules/swagger-ui-dist/swagger-ui-standalone-preset.js',
                './node_modules/swagger-ui-dist/favicon-16x16.png',
                './node_modules/swagger-ui-dist/favicon-32x32.png'
            ]
        }),
    ],
    externals: {
        'internal-apigateway-swagger': 'commonjs2 internal-apigateway-swagger',
    }
}
