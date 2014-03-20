(function() {
  module.exports = function(server) {
    var votes;
    votes = require('./votes');
    return votes = votes(server);
  };

}).call(this);
