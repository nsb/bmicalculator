'use strict';

require('basscss/css/basscss.css');
require('font-awesome/css/font-awesome.css');
require('./images/launcher-icon-1x.png')
require('./manifest.json')

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode);
