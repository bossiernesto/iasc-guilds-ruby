
def get_ractor_number(r)
  r.to_s.match(/Ractor:#[0-9]+/)[0].gsub(/\D/, '')
end

def fib(n)
  return 1 if n.zero?

  return 1 if n == 1

  fib(n - 1) + fib(n - 2)
end

# calculate fib(RN)
RN = 42
rs = (1..RN).map do |i|
  Ractor.new i do |j|
    puts "\e[0;34;49mOn Ractor[#{self}] created to calculate fib(#{get_ractor_number(self)})\e[0m"
    [j, fib(j)]
  end
end

# wait for all Ractors to finish, similar to join
until rs.empty?
  r, v = Ractor.select(*rs)
  rs.delete r
  puts "\e[0;32;49mRactor #{get_ractor_number(r)} has asnwered for fib(#{v.first}): #{v.last}\e[0m"
end