const { environment } = require('@rails/webpacker')
const setupAdminos = require('adminos/webpacker');
const webpack = require('webpack')

setupAdminos(environment);

module.exports = environment
