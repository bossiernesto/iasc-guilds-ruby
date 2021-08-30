
require 'json'
require_relative 'override'
require_relative 'redis_wrapper'
require_relative 'fibonacci_worker'
require_relative 'config'

class Offloader
  WORKERS = Config.new.config[:workers]
  attr_reader :ractor_pipeline

  def initialize
    super
    start_pipeline
    start_workers
    start_loop
  end

  def start_pipeline
    @ractor_pipeline = Ractor.new do
      loop do
        message = Ractor.recv
        puts "\e[0;34;49mOn Ractor[#{self}] received message (#{message})\e[0m"
        Ractor.yield message
        puts "\e[0;34;49mOn Ractor[#{self}] yielded message through pipeline\e[0m"
      end
    end
    puts "Started pipeline successfully #{ractor_pipeline}"
  end

  def start_workers
    (1..WORKERS).map do |worker_id|
      puts "\e[0;32;49mStarting loop for Ractor a.k.a Worker #{worker_id}\e[0m"
      Ractor.new(worker_id, ractor_pipeline) do |worker_id, pipe|
        loop do
          puts "\e[0;32;49mStarting new loop run for Ractor #{worker_id}\e[0m"
          incomming_message = pipe.take
          puts "\e[0;34;49m[Debug:Ractor##{worker_id}] - message: ##{incomming_message}\e[0m"
          raise unless incomming_message.is_a?(Hash)
          WorkerRunner.perform(worker_id, incomming_message.symbolize_keys)
        end
      end
    end
  end

  def start_loop
    loop do
      message = get_message
      # pass if no job is present
      next if message.nil?
      puts "Raw message from #{message.first} #{message}"
      # send message to ractor pipeline
      ractor_pipeline.send(JSON.parse(message[1]))
    end
  end

  private

  def get_message
    RedisWrapper.conn.blpop(['queue:ractor-example'], 1)
  end

  def get_ractor_number(r)
    r.to_s.match(/Ractor:#[0-9]+/)[0].gsub(/\D/, '')
  end

  class WorkerRunner
    def self.perform(worker_id, message)
      klass = message[:klass]
      data = message[:data]

      result =  Object.const_get(klass).new.perform(data)
      puts "\e[0;32;49mRactor #{worker_id} has asnwered for fib(#{data}): #{result}\e[0m"
    end
  end

end
Offloader.new
