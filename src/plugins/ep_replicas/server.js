var log4js = require('log4js');
var messageLogger = log4js.getLogger('message');

exports.redisSentinelAdapter = function(hook_name, args, cb) {
  const redisAdapter = require('socket.io-redis');
  const Redis = require('ioredis');

  const options = {
    sentinels: [{host: 'redis-sentinel', port: 26379}],
    name: 'sauron',
  };

  args.io.adapter(
    redisAdapter({
      pubClient: new Redis(options),
      subClient: new Redis(options),
    }),
  );
};
