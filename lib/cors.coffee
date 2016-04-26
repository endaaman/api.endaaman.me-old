url = require 'url'
config = require '../config'


# めんどいのでつかいません！！
module.exports = (next)->
    allowed = false
    if config.prod
        { referer } = @req.headers
        if referer
            { host } = url.parse referer
            if -1 < ['enda.local', 'endaaman.me'].indexOf host
                @set 'Access-Control-Allow-Origin', host
                allowed = true
    else
        @set 'Access-Control-Allow-Origin', '*'
        allowed = true

    if allowed
        methods = ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE']
        @set 'Access-Control-Allow-Methods', methods.join ','

        headers = ['Content-Type', 'Authorization', 'Accept']
        @set 'Access-Control-Allow-Headers', headers.join ','

    if @method is 'OPTIONS'
        @status = 204
    else
        yield next
