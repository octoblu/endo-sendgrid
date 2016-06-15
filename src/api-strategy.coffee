_ = require 'lodash'
PassportStrategy = require 'passport-strategy'

class SendgridStrategy extends PassportStrategy
  constructor: (env) ->
    throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_CLIENT_ID') if _.isEmpty env.ENDO_SENDGRID_SENDGRID_OAUTH_URL
    @authorizationURL = env.ENDO_SENDGRID_SENDGRID_OAUTH_URL
    super

  authenticate: (req, options) -> # keep this skinny
    return @redirect @authorizationURL unless req.body.apiKey
    @success {id: 'foo'}


module.exports = SendgridStrategy
