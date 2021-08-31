shared = Ractor.new{}
shared.instance_variable_set(:@iv, 'str')

r = Ractor.new shared do |shared|
  p shared.instance_variable_get(:@iv)
end

begin
  r.take
rescue Ractor::RemoteError => e
  e.cause.message #=> can not access instance variables of shareable objects from non-main Ractors (Ractor::IsolationError)
end