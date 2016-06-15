{afterEach, beforeEach, describe, it} = global
{expect} = require 'chai'

Endo          = require 'endo-core'
_             = require 'lodash'
request       = require 'request'
enableDestroy = require 'server-destroy'
shmock        = require 'shmock'
url           = require 'url'

ENDO_DEFAULTS = require '../endo-defaults.cson'
ENDO_DEVICE   = require '../endo-device.cson'
ApiStrategy   = require '../../src/api-strategy'

describe 'Authentication with Sendgrid', ->
  beforeEach 'start Meshblu', ->
    @meshblu = shmock()
    enableDestroy @meshblu
    @meshblu.get('/v2/whoami').reply 200, ENDO_DEVICE
    @meshblu.post('/authenticate').reply 204
    @meshblu.post('/search/devices').reply 200, []
    @meshblu.post('/devices').reply 201, {uuid: 'it'}
    @meshblu.post('/devices/it/tokens').reply 201, {uuid: 'it', token: 'ti'}
    @meshblu.put('/v2/devices/it').reply 204
    @meshblu.post('/v2/devices/it/subscriptions/it/message.received').reply 201

  beforeEach 'start Endo', (done) ->
    @sut = new ApiStrategy {
      ENDO_SENDGRID_SENDGRID_OAUTH_URL: 'http://form.biz'
    }

    endoOptions = {
      apiStrategy: @sut
      meshbluConfig:
        port: @meshblu.address().port
      userDeviceManagerUrl: 'http://manager.biz'
    }
    @endo = new Endo _.defaultsDeep endoOptions, ENDO_DEFAULTS
    @endo.run done

  beforeEach 'Set request defaults', ->
    @request = request.defaults {
      followRedirect: false
      auth:
        username: 'bogus'
        password: 'also bogus'
      baseUrl: url.format
        protocol: 'http'
        hostname: 'localhost'
        port: @endo.address().port
    }

  afterEach (done) ->
    @endo.stop done

  afterEach (done) ->
    @meshblu.destroy done

  describe 'When an Octoblu is authenticated', ->
    describe 'When Sendgrid authentication is not sent', ->
      beforeEach 'making the request', (done) ->
        @request.get '/auth/api', (error, @response) =>
          done error

      it 'should redirect to the Form Service', ->
        {hostname, query} = url.parse @response.headers.location, true
        expect(hostname).to.deep.equal 'form.biz', @response.body
        expect(query).to.deep.equal
          schemaUrl: ''
          postUrl: ''
          bearerToken: ''

    describe 'When Sendgrid authentication is sent', ->
      beforeEach 'making the request', (done) ->
        body = {apiKey: 'zaboomafoo'}
        @request.post '/auth/api/callback', json: body, (error, @response) =>
          done error

      it 'should redirect to the endo-manager', ->
        {hostname} = url.parse @response.headers.location
        expect(hostname).to.deep.equal 'manager.biz', JSON.stringify @response.body
