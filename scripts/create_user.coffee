#!/usr/bin/env coffee

username = process.argv[2]
password = process.argv[3]

if not username and not password
    console.warn 'Please specify username and password'
    process.exit 1



mongoose = require 'mongoose'
config = require '../config'

finalizer = ->
    mongoose.disconnect()



mongoose.model 'User', require '../model/user'
mongoose.connect config.db

User = mongoose.model 'User'

user = new User
    username: username
    password: password

user.save().then ->
    console.info 'Successfully created user'
, (err)->
    console.info 'Failed to create user'
    console.warn err

.then finalizer, finalizer

process.on 'SIGINT', finalizer
