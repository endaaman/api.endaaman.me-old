mongoose = require 'mongoose'

Schema = mongoose.Schema

module.exports = new Schema
    title:
        type: String
        required: true
        index:
            unique: true

    digest:
        type: String
        default: ''

    draft:
        type: Boolean
        required: true

    content:
        type: String
        required: true

    created_at:
        type: Date
        default: Date.now
        
    updated_at:
        type: Date
        default: Date.now
