koa = require 'koa'

cors = require 'koa-cors'
logger = require 'koa-logger'
responseTime = require 'koa-response-time'
bodyParser = require 'koa-bodyparser'
json = require 'koa-json'

config = require './config'

console.log cors

app = koa()
app
.use cors config.cors
.use logger()
.use responseTime()
.use bodyParser()
.use json
    pretty: true
    param: 'pretty'

require('./auth') app
require('./mecab') app
require('./memo') app

app.listen config.listen
