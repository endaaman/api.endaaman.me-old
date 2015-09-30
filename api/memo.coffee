_ = require 'lodash'
mongoose = require 'mongoose'

auth = (require '../lib/auth') true
user = (require '../lib/auth') false
config = require '../config'

Memo = mongoose.model 'Memo'

router = do require 'koa-router'

router.get '/', user, (next)->
    query = {}
    if not @user
        query.draft = false

    fields = '-content'

    opt =
        created_at: -1

    if limit = Number @query.limit
        opt.limit = limit
    if skip = Number @query.skip
        opt.skip = skip

    q = Memo.find query, fields, opt
    @body = yield q.exec()
    yield next


router.post '/', auth, (next)->
    memo = new Memo @request.body
    memo.created_at = new Date
    memo.updated_at = memo.created_at
    try
        @body = yield memo.save()
        @status = 201
    catch err
        @body = err
        @status = 422
    yield next


router.get '/:idOrTitle', user, (next)->
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


router.patch '/:id', auth, (next)->
    doc = yield Memo.findById @params.id
    if not doc
        @status = 404
        return
    base = _.clone @request.body
    delete base.created_at
    base.updated_at = new Date
    _.assign doc, base

    try
        @body = yield doc.save()
        @status = 200
    catch err
        @body = err
        @status = 422
    yield next


router.delete '/:id', auth, (next)->
    yield Memo.findByIdAndRemove @params.id
    @status = 204
    yield next


module.exports = router.routes()
