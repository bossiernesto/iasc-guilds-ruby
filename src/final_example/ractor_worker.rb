require 'json'
require_relative 'redis_wrapper'

module RactorWorker
  module ClassMethods
    def perform_async(data)
      RedisWrapper.conn.rpush(
        'queue:ractor-example', { 'klass' => self.name, 'data' => data }.to_json
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