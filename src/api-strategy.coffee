_                = require 'lodash'
PassportStrategy = require 'passport-strategy'
request          = require 'request'
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
    @_apiUrl           = env.ENDO_SENDGRID_SENDGRID_API_URL ? 'https://api.sendgrid.com'
    super

  authenticate: (req) -> # keep this skinny
    {bearerToken} = req.meshbluAuth
    return @redirect @authorizationUrl({bearerToken}) unless req.body.apiKey
    @getUserRecordFromSendgrid req.body.apiKey, (error, user) =>
      return @fail 401 if error? && error.code < 500
      return @error error if error?
      return @fail 404 unless user?
      @success {
        id:       user.user_id
        username: user.username
        secrets:
          credentials:
            secret: req.body.apiKey
      }

  authorizationUrl: ({bearerToken}) ->
    {protocol, hostname, port, pathname} = url.parse @_authorizationUrl
    query = {
      postUrl: @postUrl()
      schemaUrl: @schemaUrl()
      bearerToken: bearerToken
    }
    return url.format {protocol, hostname, port, pathname, query}

  getUserRecordFromSendgrid: (apiKey, callback) =>
    options = {
      baseUrl: @_apiUrl
      auth: {bearer: apiKey}
      json:true
    }

    request.get '/v3/user/username', options, (error, response, body) =>
      return callback error if error?
      console.log 'response', body
      return callback @_userError(401, "Api key was invalid: #{JSON.stringify body}") unless response.statusCode == 200
      callback()

  postUrl: ->
    {protocol, hostname, port} = url.parse @_callbackUrl
    return url.format {protocol, hostname, port, pathname: '/auth/api/callback'}

  schemaUrl: ->
    @_schemaUrl

  _userError: (code, message) =>
    error = new Error message
    error.code = code
    return error


module.exports = SendgridStrategy
