require 'json'
require_relative 'config'
require_relative 'redis_wrapper'

module RactorWorker
  module ClassMethods
    def perform_async(data)
      RedisWrapper.conn.rpush(
        Config.new.config[:queue], { 'klass' => self.name, 'data' => data }.to_json
      )
      :ok
    end
  end

  def perform
    raise NotImplementedError
  end

  def self.included(base_klass)
    base_klass.extend ClassMethods
  end
end