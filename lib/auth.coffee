_ = require 'lodash'
Q = require 'q'
mongoose = require 'mongoose'
jwt = require 'jsonwebtoken'

config = require '../config'

jwtVerify = Q.nbind jwt.verify, jwt
User = mongoose.model 'User'


module.exports = (restricted)->
    (next)->
        # Header style
        #   Authorization: Bearer TOKEN_STRING
        @user = null
        authStyle = 'Bearer'

        abort = (next)->
            if restricted
                @status = 401

        if not @request.header.authorization?
            if restricted
                @throw 401
            else
                yield next
                return

        parts = @request.header.authorization.split ' '
        validTokenStyle = parts.length is 2 and parts[0] is authStyle

        if not validTokenStyle
            if restricted
                @throw 401
            else
                yield next
                return

        token = parts[1]
        try
            decoded = yield jwtVerify token, config.secret
        catch
            if restricted
                @throw 401
            else
                yield next
                return

        doc = yield User.findById decoded._id

        if not doc or not doc.approved
            if restricted
                @throw 401
            else
                yield next
                return

        @user =  (_.pick doc, ['_id', 'username', 'approved'])

        yield next
