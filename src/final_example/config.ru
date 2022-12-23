require 'bundler/setup'

require 'active_support/all'
require 'sinatra'
require 'sinatra/base'
require_relative 'fibonacci_worker'

helpers do
  def calculate_fib(n)
    raise if n < 0
    range = 0..n
    range.map do |n|
      FibonacciWorker.perform_async({ n: n })
    end
    :ok
  end

  def fib(n)
    return 1 if n.zero?

    return 1 if n == 1

    fib(n - 1) + fib(n - 2)
  end
end

get '/' do
  send_file 'fibo_calculator.html'
end

get '/fibonacci/:n' do
  {result: fib(params[:n].to_i)}.to_json
end

get '/async_fibonacci' do
  {result: calculate_fib(40)}.to_json
end

get '/async_fibonacci/:n' do
  {result: calculate_fib(params[:n].to_i)}.to_json
end

run Sinatra::Application
