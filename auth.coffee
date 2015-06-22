Q = require 'q'
db = require('monk') 'localhost:27017/enda'
users = db.get 'users'
bcrypt = require 'bcrypt'
router = require('koa-router')()
_ = require 'lodash'
jwt = require 'jsonwebtoken'


bcryptGenSalt = Q.nbind bcrypt.genSalt, bcrypt
bcryptHash = Q.nbind bcrypt.hash, bcrypt
bcryptCompare = Q.nbind bcrypt.compare, bcrypt
jwtVerify = Q.nbind jwt.verify, jwt

secret = process.env.SECRET or console.log('[WARN]: secret was set dengerous key') or 'THIS_IS_DEGEROUS'

auth = (next)->
    # Header style
    #   Authorization: Bearer TOKEN_STRING

    authStyle = 'Bearer'

    @token = {}
    @throw 401 if not @request.header.authorization?

    parts = @request.header.authorization.split ' '
    validTokenStyle = parts.length is 2 and parts[0] is authStyle

    @throw 401 if not @request.header.authorization?

    token = parts[1]

    decoded = yield jwtVerify token, secret
    .fail (e)=>
        console.log e
        @throw 401

    @user = decoded

    yield next


router.post '/users', (next)->
    valid = @request.body.username and @request.body.password
    if not valid
        @throw 400

    doc = yield users.findOne username: @request.body.username
    if doc
        @throw 400

    salt = yield bcryptGenSalt 10
    password = yield bcryptHash @request.body.password, salt

    user =
        username: @request.body.username
        password: password
        salt: salt

    doc = yield users.insert user
    @body = _.pick doc, ['_id', 'username']
    @status = 200
    yield next


router.get '/users', auth, (next)->
    docs = yield users.find {}, ['_id', 'username']
    @body = docs
    yield next



router.post '/session', (next)->
    doc = yield users.findOne username: @request.body.username
    if not doc
        @throw 400

    ok = yield bcryptCompare @request.body.password, doc.password

    if not ok
        @throw 400
        return

    token = jwt.sign (_.pick doc, ['_id', 'username']), secret
    @body =
        token: token
    @status = 201
    yield next


router.get '/session', auth, (next)->
    @body = ''
    @status = 200
    yield next


module.exports = (app)->
    app
    .use router.routes()
    .use router.allowedMethods()

module.exports.auth = auth
