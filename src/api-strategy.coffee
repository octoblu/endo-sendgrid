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
    if _.isEmpty env.ENDO_SENDGRID_SENDGRID_FORM_SCHEMA_URL
      throw new Error('Missing required environment variable: ENDO_SENDGRID_SENDGRID_FORM_SCHEMA_URL')


    @_authorizationUrl = env.ENDO_SENDGRID_SENDGRID_AUTH_URL
    @_callbackUrl      = env.ENDO_SENDGRID_SENDGRID_CALLBACK_URL
    @_schemaUrl        = env.ENDO_SENDGRID_SENDGRID_SCHEMA_URL
    @_formSchemaUrl    = env.ENDO_SENDGRID_SENDGRID_FORM_SCHEMA_URL
    @_apiUrl           = env.ENDO_SENDGRID_SENDGRID_API_URL ? 'https://api.sendgrid.com'
    super

  authenticate: (req) -> # keep this skinny
    {bearerToken} = req.meshbluAuth
    {username, password} = req.body
    return @redirect @authorizationUrl({bearerToken}) unless username? && password?
    @getUserRecordFromSendgrid {username, password}, (error, user) =>
      return @fail 401 if error? && error.code < 500
      return @error error if error?
      return @fail 404 unless user?
      @success {
        id:       user.username
        username: user.username
        secrets:
          credentials: {username, password}
      }

  authorizationUrl: ({bearerToken}) ->
    {protocol, hostname, port, pathname} = url.parse @_authorizationUrl
    query = {
      postUrl: @postUrl()
      schemaUrl: @schemaUrl()
      formSchemaUrl: @formSchemaUrl()
      bearerToken: bearerToken
    }
    return url.format {protocol, hostname, port, pathname, query}

  formSchemaUrl: ->
    @_formSchemaUrl

  getUserRecordFromSendgrid: ({username, password}, callback) =>
    options = {
      baseUrl: @_apiUrl
      uri: '/api/profile.get.json'
      qs:
        api_user: username
        api_key:  password
      json:true
    }

    request.get options, (error, response, body) =>
      return callback error if error?
      return callback @_userError(401, "Api key was invalid: #{JSON.stringify body}") if body.error?
      callback null, _.first body

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
