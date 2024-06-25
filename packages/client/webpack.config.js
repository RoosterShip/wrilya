const path = require("path");
const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const CopyPlugin = require("copy-webpack-plugin")

let globalVals = "./src/globalsProd.ts";

// eslint-disable-next-line no-undef
if (process.env.NODE_ENV === "development") {
    globalVals = "./src/globalsDev.ts"
}

module.exports = {
    entry: {
        globals: "./src/globals.ts",
        values: globalVals,
        main: "./src/index.ts"
    },
    optimization: {
        splitChunks: {
            cacheGroups: {
                phaser: {
                    test: /[\\/]node_modules[\\/]phaser[\\/]/,
                    name: "phaser",
                    chunks: "all",
                },
                phasereditor2d: {
                    test: /[\\/]node_modules[\\/]@phasereditor2d[\\/]/,
                    name: "phasereditor2d",
                    chunks: "all",
                }
            }
        }
    },
    output: {
        path: path.resolve(__dirname, "dist"),
        filename: "[name]-[contenthash].bundle.js",
        assetModuleFilename: "asset-packs/[name]-[hash][ext][query]",
    },
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                use: "ts-loader",
                exclude: /node_modules/,
            }
            // Removed because Webpack
            //{
            //    test: /\.json/,
            //    type: "asset/resource",
            //    exclude: /node_modules/,
            //}
        ],
    },
    resolve: {
        extensions: [".tsx", ".ts", ".js"],
    },
    devServer: {
        historyApiFallback: true,
        allowedHosts: 'all',
        static: {
            directory: path.resolve(__dirname, "./dist"),
        },
        open: true,
        hot: true,
        port: 8080,
    },
    //watch: true,
    watchOptions: {
        poll: 1000, // Check for changes every second
        ignored: /node_modules/,
        followSymlinks: true,
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: path.join(__dirname, "src/index.html"),
            minify: false
        }),
        new CleanWebpackPlugin(),
        new CopyPlugin({
            patterns: [
                {
                    from: "static",
                    globOptions: {
                        // asset pack files are imported in code as modules
                        ignore: ["**/publicroot", "**/*-pack.json"]
                    }
                }
            ]
        }),
        new webpack.HotModuleReplacementPlugin(),
    ]
};
