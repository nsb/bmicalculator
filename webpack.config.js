var path = require("path");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    // path: path.resolve(__dirname + '/dist'),
    path: path.resolve('../bmicalculator-dist'),
    filename: '[name].js',
  },

  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("style-loader", "css-loader")
      },
      // {
      //   test: /\.(css|scss)$/,
      //   loaders: [
      //     'style-loader',
      //     'css-loader',
      //   ]
      // },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&minetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg|png)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
      {
        test: /\.(json)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file?name=[name].[ext]',
      },
    ],

    noParse: /\.elm$/,
  },

  plugins: [
      new ExtractTextPlugin("[name].css")
  ],

  devServer: {
    inline: true,
    stats: { colors: true },
  },


};
