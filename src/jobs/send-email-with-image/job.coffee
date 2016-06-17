http       = require 'http'
_          = require 'lodash'
nodemailer = require 'nodemailer'
url        = require 'url'

class SendEmailWithImage
  constructor: ({encrypted}) ->
    console.log JSON.stringify {encrypted}
    {username, password} = encrypted.secrets.credentials

    @mailer = nodemailer.createTransport url.format({
      protocol: 'smtps'
      hostname: 'smtp.sendgrid.net'
      port: 465
      auth: "#{username}:#{password}"
    })

  do: ({data}, callback) =>
    @mailer.sendMail @mailOptions(data), (error, info) =>
      callback error, info

  mailOptions: ({from, to, subject, text, html, filename, image}) =>
    return {from, to, subject, text, html, attachments: [{ filename, content: new Buffer(image, 'base64') }]}

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
