pipe = Ractor.new do
  loop do
    Ractor.yield Ractor.receive
  end
end

RN = 10
rs = RN.times.map{|i|
  Ractor.new pipe, i do |pipe, i|
    msg = pipe.take
    msg # ping-pong
  end
}
RN.times{|i|
  pipe << i
}

# TODO: select syntax of go-language uses round-robin technique to make fair scheduling.
# Now Ractor.select() doesn't use it.
pp RN.times.map{
  r, n = Ractor.select(*rs)
  rs.delete r
  n
} #=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]