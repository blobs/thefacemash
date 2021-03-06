
getRandomToken = () ->
  require('crypto')
    .randomBytes(3)
    .toString('hex')

calculateHash = (data) ->
  require('crypto')
    .createHash('sha1')
    .update(data.token + data.first.toString() + data.second.toString())
    .digest('hex')

module.exports = (server) ->

  recalculateRating = (firstId, secondId, firstWin, callback) ->
    first = {}
    second = {}
    console.log('step 1')
    server.client
      .multi()
      .zscore('scores', firstId)
      .zscore('scores', secondId)
      .exec((err, replies) ->
        console.log('step 2')
        if err?
          console.log('false error', err)
          callback(err)
        else
          first.old = parseFloat(replies[0] || 1500)
          second.old = parseFloat(replies[1] || 1500)
          console.log(first.old, second.old, typeof first.old, typeof second.old)
          first.coefficient = 20
          second.coefficient = 20
          first.expectation = 1 / (1 +  Math.pow 10, (second.old - first.old) / 400)
          second.expectation = 1 / (1 +  Math.pow 10, (first.old - second.old) / 400)
          console.log(first.expectation, second.expectation)
          first.answer = Math.round first.old + first.coefficient * ((if firstWin then 1 else 0) - first.expectation)
          second.answer = Math.round second.old + second.coefficient * ((if firstWin then 0 else 1) - second.expectation)
          server.client.zadd('scores', first.answer, firstId)
          server.client.zadd('scores', second.answer, secondId)
          console.log(first.answer, second.answer)
      )

  server.get '/battle', (req, res, next) ->
    answer =
      token: getRandomToken(),
      first: 0,
      second: 0,
      sign: 0
    server.client.srandmember 'people', 2, (err, data) ->
      answer.first = data[0]
      answer.second = data[1]
      server.client.zadd 'tokens', Date.now() + 1000 * 60,  answer.sign = calculateHash(answer)
      res.send answer
      next()

  server.get '/battle/:id', (req, res, next) ->
    server.client.multi()
      .zremrangebyscore('tokens', 0, Date.now())
      .zscore('tokens', req.params.sign, (err, data) ->
        next.ifError err
        if not data
          next new server.restify.ForbiddenError 'token invalid'
        else if req.params.sign == calculateHash(req.param)
          server.client.zrem 'tokens', req.params.sing
          console.log(req.params)
          recalculateRating(req.params.first, req.params.second, req.params.firstWin, () ->)
          res.send 'ok'
          next()
      )
      .exec()
