Q = require 'q'
MeCab = new require 'mecab-async'
mecab = new MeCab()

router = require('koa-router')()

router.post '/mecab', (next)->
    if @request.body.text?
        if @request.body.wakachi
            text = yield Q.nfcall mecab.wakachi, @request.body.text
        else
            text = yield Q.nfcall mecab.parse, @request.body.text
        @statusCode = 200
        @body =
            text: text
        yield next
    else
        @res.statusCode = 400
        yield next

module.exports = (app)->
    app
    .use router.routes()
    .use router.allowedMethods()
