_ = require 'lodash'
mongoose = require 'mongoose'

auth = require '../lib/auth'
config = require '../config'

Memo = mongoose.model 'Memo'

router = do require 'koa-router'

router.get '/', (next)->
    query = {}
    if not @user
        query.hidden = false

    q = Memo.find query, {}, sort: '-created_at'
    @body = yield q.exec()
    yield next


router.post '/', auth, (next)->
    memo = new Memo @request.body

    @body = yield memo.save()
    @status = 201
    yield next


router.patch '/:id', auth, (next)->
    doc = yield Memo.findById @params.id
    if not doc
        @status = 404
        return
    _.assign doc, @request.body

    @body = yield doc.save()
    @status = 200
    yield next



router.get '/:idOrTitle', (next)->
    idOrTitle = @params.idOrTitle
    if /^[0-9a-fA-F]{24}$/.test idOrTitle
        doc = yield Memo.findById idOrTitle
    else
        doc = yield Memo.findOne title: idOrTitle

    if not doc
        @status = 404
        return

    if doc.draft and not @user?
        @status = 404
        return

    @body = doc
    yield next



router.delete '/:id', auth, (next)->
    yield Memo.findByIdAndRemove @params.id
    @status = 204
    yield next


module.exports = router.routes()
