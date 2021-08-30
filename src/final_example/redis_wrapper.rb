require 'redis'
require_relative 'config'

class RedisWrapper
  def self.conn
    @@redis ||= Redis.new(password: Config.new.config[:redis_pass])
  end
end