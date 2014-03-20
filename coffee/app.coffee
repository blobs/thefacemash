restify = require 'restify'
redis = require 'redis'
client = redis.createClient()
server = restify.createServer()
server.listen(process.env.PORT || 3000)
routes = require './routes/index'
server.client = client
server.restify = restify
server.use restify.queryParser()
routes = routes server

