get = (req, res, next) ->
  answer =
    first: 14385
    second: 11252
    token: 'fhsa4yw4erysert43terts'
  res.send answer
  next
module.exports = (server) ->
  server.get '/', get
