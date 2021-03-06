http       = require 'http'
nodemailer = require 'nodemailer'
url        = require 'url'

class SendEmail
  constructor: ({encrypted}) ->
    {username, password} = encrypted.secrets.credentials

    @mailer = nodemailer.createTransport url.format({
      protocol: 'smtps'
      hostname: 'smtp.sendgrid.net'
      port: 465
      auth: "#{username}:#{password}"
    })

  do: ({data}, callback) =>
    @mailer.sendMail @mailOptions(data), (error) =>
      return callback error if error?
      callback null, {
        metadata:
          code: 201
          status: http.STATUS_CODES[201]
      }

  mailOptions: ({from, to, subject, text, html}) =>
    return {from, to, subject, text, html}

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error

module.exports = SendEmail
