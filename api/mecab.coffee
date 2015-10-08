Q = require 'q'
MeCab = new require 'mecab-async'
mecab = new MeCab()

router = do require 'koa-router'

router.get '/:text', (next)->
    text = @params.text
    if @query.wakachi?
        result = yield Q.nfcall mecab.wakachi, text
    else
        result = yield Q.nfcall mecab.parse, text
    @body = result
    yield next

module.exports = router.routes()
