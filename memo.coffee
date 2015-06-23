_ = require 'lodash'
Q = require 'q'
db = require('monk') 'localhost:27017/enda'
memos = db.get 'memos'

auth = require('./auth').auth

router = require('koa-router')
    prefix: '/memos'

router.get '/', (next)->
    docs = yield memos.find @request.query,
        sort:
            created_at: -1
        fields: '-content'
    @body = docs
    yield next



router.post '/', auth, (next)->
    memo = _.clone @request.body
    memo.created_at = new Date
    memo.updated_at = memo.created_at
    doc = yield memos.insert memo
    @body = doc
    yield next


router.get '/:title', (next)->
    doc = yield memos.findOne title: this.params.title
    if doc
        @body = doc
    else
        @status = 404
    yield next


router.put '/:id', auth, (next)->
    memo = _.clone @request.body
    if memo.created_at
        delete memo.created_at
    memo.updated_at = new Date
    yield memos.updateById this.params.id, $set: memo
    @body = memo
    yield next


router.delete '/:id', auth, (next)->
    yield memos.remove _id: this.params.id
    @body = ''
    yield next


module.exports = (app)->
    app
    .use router.routes()
    .use router.allowedMethods()
