require_relative 'override'
require 'yaml'

class Config
  attr_reader :config

  def initialize
    @config = YAML.load(
      File.open('./config.yml').read
    )
    @config = @config.symbolize_keys
  end
end

