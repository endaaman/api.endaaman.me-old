path = require 'path'

prod = process.env.NODE_ENV is 'production'

cors = ->
    methods = ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE']
    if prod
        origin: 'http://endaaman.me'
        headers: ['Content-Type', 'Authorization', 'Accept', 'If-Modified-Since']
        methods: methods
    else
        origin: true
        methods: methods

secret = ->
    if not process.env.SECRET
        console.warn 'secret was set dengerous key'
    process.env.SECRET or 'THIS_IS_DENGEROUS_SECRET'


module.exports =
    cors: cors()
    uploadDir: '/var/uploaded/enda'
    basePath: '/'
    port: 3000
    portSeo: 3001
    secret: secret()
    db: 'mongodb://localhost:27017/enda'
