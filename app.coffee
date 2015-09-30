mongoose = require 'mongoose'

koa = require 'koa'

cors = require 'koa-cors'
logger = require 'koa-logger'
responseTime = require 'koa-response-time'
bodyParser = require 'koa-bodyparser'
json = require 'koa-json'

config = require './config'


mongoose.model 'User', require './model/user'
mongoose.model 'Memo', require './model/memo'
mongoose.connect config.db


app = koa()
app
.use cors config.cors
.use logger()
.use responseTime()
.use bodyParser()
.use json
    pretty: not config.prod

api = new (require 'koa-router')

api.use '/users', require './api/user'
api.use '/session', require './api/session'
api.use '/memos', require './api/memo'
api.use '/files', require './api/file'
api.use '/mecab', require './api/mecab'
api.get '/', (next)->
    @body =
        message: 'Welcome to api.endaaman.me'
    yield next

# API server
app
.use api.routes()
.use api.allowedMethods()
.listen config.port

# SEO server
http  = require 'http'
spaseo = require 'spaseo.js'
http.createServer spaseo
    verbose: not config.prod
.listen config.portSeo
