(function() {
  var get;

  get = function(req, res, next) {
    var answer;
    answer = {
      first: 14385,
      second: 11252,
      token: 'fhsa4yw4erysert43terts'
    };
    res.send(answer);
    return next;
  };

  module.exports = function(server) {
    return server.get('/', get);
  };

}).call(this);
