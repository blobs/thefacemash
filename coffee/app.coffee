restify = require 'restify'
server = restify.createServer()
server.listen(process.env.PORT || 3000)
routes = require './routes/index'
routes = routes server
