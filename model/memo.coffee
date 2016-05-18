mongoose = require 'mongoose'

Schema = mongoose.Schema

module.exports = new Schema
    slug:
        type: String
        # required: true # auto set from _id
    title:
        type: String
        required: true

    digest:
        type: String
        default: ''

    draft:
        type: Boolean
        required: true
        default: false

    image_url:
        type: String
        default: ''

    content:
        type: String
        required: true

    created_at:
        type: Date
        default: Date.now

    updated_at:
        type: Date
        default: Date.now

.pre　'save', (next)->
    if not @slug
        @slug = @_id
    next()
