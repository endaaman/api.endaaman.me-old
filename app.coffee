mongoose = require 'mongoose'

koa = require 'koa'

cors = require 'koa-cors'
logger = require 'koa-logger'
responseTime = require 'koa-response-time'
bodyParser = require 'koa-bodyparser'
json = require 'koa-json'
serve = require 'koa-static'
Router = new require 'koa-router'

config = require './config'


mongoose.model 'User', require './model/user'
mongoose.model 'Memo', require './model/memo'
mongoose.connect config.db


app = koa()
app
.use logger()
.use responseTime()
.use bodyParser()
.use json
    pretty: not config.prod


root = new Router

api = new Router prefix: '/api'

api.use '/users', require './api/user'
api.use '/session', require './api/session'
api.use '/memos', require './api/memo'
api.use '/files', require './api/file'
api.use '/mecab', require './api/mecab'
api.get '/', (next)->
    @body =
        message: 'Welcome to api.endaaman.me'
    yield next

root.use api.routes()

if not config.prod
    root.get '/static/*', (next)->
        parts = @path.split '/'
        parts.splice 1, 1
        @path = parts.join '/'
        console.log @path
        yield next
    , serve config.uploadDir

# API server
app
.use root.routes()
.use root.allowedMethods()
app.listen config.port

console.info 'Started enda-api server.'
