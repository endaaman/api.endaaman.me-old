mongoose = require 'mongoose'

koa = require 'koa'

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

if not config.prod
    app
    .use logger()

app
.use responseTime()
.use bodyParser()
.use json
    pretty: not config.prod
.use (next)->
    @set 'Access-Control-Allow-Origin', '*'
    methods = ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE']
    @set 'Access-Control-Allow-Methods', methods.join ','

    headers = ['Content-Type', 'Authorization', 'Accept']
    @set 'Access-Control-Allow-Headers', headers.join ','
    if @method is 'OPTIONS'
        @status = 204
    else
        yield next

.use require './lib/user'
.use (next)->
    try
        yield next
    catch e
        if e instanceof mongoose.Error.ValidationError
            @status = 422
            @body = e.errors
            return
        else
            throw e

root = new Router

api = new Router prefix: ''
# api.use (next)->
#     @set 'Access-Control-Allow-Origin', '*'
#     yield next
api.use '/users', require './api/user'
api.use '/session', require './api/session'
api.use '/memos', require './api/memo'
api.use '/files', require './api/file'
api.get '/', (next)->
    @body =
        message: 'Welcome to api.endaaman.me'
    yield next

root.use api.routes()


# API server
app
.use root.routes()
.use root.allowedMethods()
app.listen config.port

console.info "Started enda-api server(mode: #{if config.prod then 'prod' else 'dev'})"
