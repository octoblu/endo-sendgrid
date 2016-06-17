http   = require 'http'
_      = require 'lodash'

class SendEmailWithImage
  constructor: ({@encrypted}) ->
    @sendgrid = require('sendgrid')(@encrypted.username, @encrypted.password)

  do: ({data}, callback) =>
    return callback @_userError(422, 'data.to is required') unless data.to?

    email = new @sendgrid.Email()
    {to, subject, from, text, html, filename, b64} = data

    email.to      = to
    email.subject = subject
    email.from    = from
    email.text    = text
    email.html    = html

    img = b64
    rawData = img.replace(/^data:image\/\w+;base64,/, "")
    file = new Buffer(rawData, 'base64')
    filename = 'octoblu.jpeg'
    email.addFile {filename: filename, content:  file}

    @sendgrid.send email, (error, json) =>
      return callback error if error?
      return callback null, {
        metadata:
          code: 200
          status: http.STATUS_CODES[200]
        data: _processResults results
      }

  _processResult: (result) =>
    {
      response: result
    }

  _processResults: (results) =>
    _.map results, @_processResult

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = SendEmailWithImage
