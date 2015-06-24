prod = process.env.NODE_ENV is 'production'

cors = ->
    if prod
        origin: 'http://endaaman.me'
        headers: ['Content-Type', 'Authorization', 'Accept']
    else
        {}

listen = ->
    # TODO: enable unix domain socket mode
    3000


module.exports =
    cors: cors()
    listen: listen()
