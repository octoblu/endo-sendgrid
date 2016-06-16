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

  beforeEach 'start Sendgrid', ->
    @sendgrid = shmock()
    enableDestroy @sendgrid

  beforeEach 'start Endo', (done) ->
    @sut = new ApiStrategy {
      ENDO_SENDGRID_SENDGRID_CALLBACK_URL: 'http://service.biz'
      ENDO_SENDGRID_SENDGRID_AUTH_URL: 'http://form.biz'
      ENDO_SENDGRID_SENDGRID_SCHEMA_URL: 'http://schema.biz/schema.json'
      ENDO_SENDGRID_SENDGRID_API_URL: "http://localhost:#{@sendgrid.address().port}"
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
        password: 'also-bogus'
      baseUrl: url.format
        protocol: 'http'
        hostname: 'localhost'
        port: @endo.address().port
    }

  afterEach 'destroy Endo', (done) ->
    @endo.stop done

  afterEach 'destroy Sendgrid', (done) ->
    @sendgrid.destroy done

  afterEach 'destroy Meshblu', (done) ->
    @meshblu.destroy done

  describe 'When an Octoblu is authenticated', ->
    describe 'When Sendgrid authentication is not sent', ->
      beforeEach 'making the request', (done) ->
        @request.get '/auth/api', (error, @response) =>
          done error

      it 'should redirect to the Form Service', ->
        {hostname} = url.parse @response.headers.location, true
        expect(hostname).to.deep.equal 'form.biz', @response.body

      it 'should pass the postUrl as a query param', ->
        {query} = url.parse @response.headers.location, true
        expect(query).to.containSubset postUrl: 'http://service.biz/auth/api/callback'

      it 'should pass the schemaUrl as a query param', ->
        {query} = url.parse @response.headers.location, true
        expect(query).to.containSubset schemaUrl: 'http://schema.biz/schema.json'

      it 'should pass the bearerToken as a query param', ->
        {query} = url.parse @response.headers.location, true
        expect(query).to.containSubset bearerToken: new Buffer('bogus:also-bogus').toString 'base64'

    describe 'When Sendgrid authentication is sent', ->
      describe 'when sendgrid validates the API key', ->
        beforeEach 'sendgrid validates', ->
          @sendgrid.get('/v3/user/username').reply 200, {username: 'joe-bob', user_id: 123}

        beforeEach 'making the request', (done) ->
          body = {apiKey: 'zaboomafoo'}
          @request.post '/auth/api/callback', json: body, (error, @response) =>
            done error

        it 'should redirect to the endo-manager', ->
          {hostname} = url.parse @response.headers.location
          expect(hostname).to.deep.equal 'manager.biz', JSON.stringify @response.body

      describe 'when sendgrid invalidates the API key', ->
        beforeEach 'sendgrid validates', ->
          @sendgrid.get('/v3/user/username').reply 401, 'Unauthorized'

        beforeEach 'making the request', (done) ->
          body = {apiKey: 'zaboomafoo'}
          @request.post '/auth/api/callback', json: body, (error, @response) =>
            done error

        it 'should yield a 401', ->
          expect(@response.statusCode).to.equal 401
