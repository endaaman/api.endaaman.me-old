_ = require 'lodash'
Q = require 'q'
bcrypt = require 'bcrypt'
jwt = require 'jsonwebtoken'
mongoose = require 'mongoose'

auth = require '../lib/auth'
config = require '../config'


User = mongoose.model 'User'
router = do require 'koa-router'

bcryptCompare = Q.nbind bcrypt.compare, bcrypt
jwtVerify = Q.nbind jwt.verify, jwt


router.post '/', (next)->
    q = User.findOne username: @request.body.username
    doc = yield q.exec()
    if not doc
        @throw 401
        return

    ok = yield bcryptCompare @request.body.password, doc.password
    if not ok
        @throw 401
        return

    user = _.pick doc, ['_id', 'username']

    token = jwt.sign (_id: doc._id), config.secret
    @body =
        token: token
        user: user
    @status = 201
    yield next


router.get '/', auth, (next)->
    @body =
        user: @user
    yield next


module.exports = router.routes()
