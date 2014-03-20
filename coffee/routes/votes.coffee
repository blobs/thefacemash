recalculateRating = (first, second, firstWin) ->
  first = {}
  second = {}
  first.expectation = 1 / (1 +  Math.pow 10, (second - first) / 400)
  second.expectation = 1 / (1 +  Math.pow 10, (first - second) / 400)
  first.answer = first.old + first.coefficient * (firstWin ? 1 : 0 - first.expectation)
  second.answer = second.old + second.coefficient * (firstWin ? 0 : 1 - second.expectation)

getRandomToken = () ->
  require('crypto')
    .randomBytes(3)
    .toString('hex')

module.exports = (server) ->
  server.get '/battle', (req, res, next) ->
    answer =
      token: getRandomToken()
    server.client.zadd 'tokens', Date.now() + 1000 * 60,  answer.token
    server.client.srandmember 'people', 2, (err, data) ->
      answer.first = data[0]
      answer.second = data[1]
      res.send answer
      next()
  server.get '/battle/:id', (req, res, next) ->
    server.client.zremrangebyscore 'tokens', 0, Date.now()
    server.client.zscore 'tokens', req.params.token, (err, data) ->
      next.ifError err
      if not data
        next new server.restify.ForbiddenError 'token invalid'
      else
        server.client.zrem 'tokens', req.params.token
        res.send data
        next()

