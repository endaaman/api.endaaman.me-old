
path = require 'path'
fs = require 'co-fs'
_ = require 'lodash'
Q = require 'q'
parse = require 'co-busboy'
cp = require 'fs-cp'
destroy = require 'destroy'

auth = require '../lib/auth'
config = require '../config'

router = do require 'koa-router'


filterFunc = (filename)->
    if /^\./.test filename
        return false
    true


router.get '/', auth, (next)->
    all = yield fs.readdir config.uploadDir
    files = []
    for i in all
        stat = yield fs.stat(file)
        if stat.isFile()
            files.push(i)
    @body = _.filter files, filterFunc
    yield next


router.post '/', auth, (next)->
    parts = parse this,
        autoFields: true
    while part = yield parts
        filepath = path.join config.uploadDir, part.filename
        yield cp part, filepath

    @status = 204
    yield next

router.delete '/:filename', auth, (next)->
    yield fs.unlink path.join config.uploadDir, @params.filename
    @status = 204
    yield next


router.post '/rename', auth, (next)->
    oldPath = path.join config.uploadDir, @request.body.filename
    newPath = path.join config.uploadDir, @request.body.new_filename
    yield fs.rename oldPath, newPath
    @status = 204
    yield next


module.exports = router.routes()
