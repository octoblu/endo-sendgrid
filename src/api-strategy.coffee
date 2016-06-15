_                = require 'lodash'
PassportStrategy = require 'passport-strategy'
url              = require 'url'

class SendgridStrategy extends PassportStrategy
  constructor: (env) ->
    throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_CLIENT_ID') if _.isEmpty env.ENDO_SENDGRID_SENDGRID_OAUTH_URL
    @authorizationURL = env.ENDO_SENDGRID_SENDGRID_OAUTH_URL
    super

  authenticate: (req, options) -> # keep this skinny
    return @redirectToAuthorizationUrl() unless req.body.apiKey
    @success {id: 'foo'}

  redirectToAuthorizationUrl: ->
    {protocol, hostname, port, pathname} = url.parse @authorizationURL
    query = {
      postUrl: ''
      schemaUrl: ''
      bearerToken: ''
    }
    return @redirect url.format {protocol, hostname, port, pathname, query}


module.exports = SendgridStrategy
