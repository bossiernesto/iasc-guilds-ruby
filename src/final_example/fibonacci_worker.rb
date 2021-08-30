require_relative 'ractor_worker'

# Fibonacci worker using Ractors that will have the perfom and perform_async methods.
class FibonacciWorker
  include RactorWorker

  # perform sync..
  def perform(data)
    fib(data['n'])
  end

  def fib(n)
    return 1 if n.zero?

    return 1 if n == 1

    fib(n - 1) + fib(n - 2)
  end
end
