prod = process.env.NODE_ENV is 'production'
local = process.env.MACHINE is 'local'

cors = ->
    if prod
        if local
            origin: 'http://enda.local'
            headers: ['Content-Type', 'Authorization', 'Accept']
        else
            origin: 'http://endaaman.me'
            headers: ['Content-Type', 'Authorization', 'Accept']
    else
        {}

listen = ->
    # TODO: enable unix domain socket mode
    # if prod
    #     '/var/tmp/enda-api.sock'
    # else
    #     3000
    3000

module.exports =
    cors: cors()
    listen: listen()
