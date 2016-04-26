path = require 'path'
crypto = require 'crypto'

prod = process.env.NODE_ENV is 'production'

secret = ->
    crypto.randomBytes(48).toString 'hex'

mongoPath = ->
    host = process.env.MONGO_HOST or 'localhost:27017'

    "mongodb://#{host}/enda"

module.exports =
    prod: prod
    uploadDir: '/var/uploaded/enda'
    basePath: '/'
    port: 3000
    secret: secret()
    db: mongoPath()
