# frozen_string_literal: true

def create_and_run_ractor(a)
  Ractor.new a do |arg|
    sleep(5)
    arg # return arg
  end
end

def ractor_example_2
  Ractor.new do
    Ractor.receive
  end
end

def receive_only_strings_ractor
  Ractor.new do
    msg = Ractor.receive_if { |msg| msg.is_a?(String) }
    msg
  end
end


def closed_ractor
  r = Ractor.new do
  end

  r.take # wait terminate

  begin
    r.send(1)
  rescue Ractor::ClosedError => e
    puts e
    'ok'
  else
    'ng'
  end
end