mongoose = require 'mongoose'

Schema = mongoose.Schema

module.exports = new Schema
    title:
        type: String
        required: true
    draft:
        type: Boolean
        required: true
        index:
            unique: true
    digest:
        type: String
    content:
        type: String
        required: true

    created_at: Date
    updated_at: Date
