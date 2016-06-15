_                = require 'lodash'
PassportStrategy = require 'passport-strategy'
url              = require 'url'

class SendgridStrategy extends PassportStrategy
  constructor: (env) ->
    if _.isEmpty env.ENDO_SENDGRID_SENDGRID_CALLBACK_URL
      throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_CALLBACK_URL')
    if _.isEmpty env.ENDO_SENDGRID_SENDGRID_AUTH_URL
      throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_AUTH_URL')
    if _.isEmpty env.ENDO_SENDGRID_SENDGRID_SCHEMA_URL
      throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_SCHEMA_URL')

    @_authorizationUrl = env.ENDO_SENDGRID_SENDGRID_AUTH_URL
    @_callbackUrl      = env.ENDO_SENDGRID_SENDGRID_CALLBACK_URL
    @_schemaUrl        = env.ENDO_SENDGRID_SENDGRID_SCHEMA_URL
    super

  authenticate: (req) -> # keep this skinny
    {bearerToken} = req.meshbluAuth
    return @redirect @authorizationUrl({bearerToken}) unless req.body.apiKey
    @success {id: 'foo'}

  authorizationUrl: ({bearerToken}) ->
    {protocol, hostname, port, pathname} = url.parse @_authorizationUrl
    query = {
      postUrl: @postUrl()
      schemaUrl: @schemaUrl()
      bearerToken: bearerToken
    }
    return url.format {protocol, hostname, port, pathname, query}

  postUrl: ->
    {protocol, hostname, port} = url.parse @_callbackUrl
    return url.format {protocol, hostname, port, pathname: '/auth/api/callback'}

  schemaUrl: ->
    @_schemaUrl


module.exports = SendgridStrategy
