require "ostruct"
require "yaml"

config = OpenStruct.new(YAML.load_file("#{Rails.root}/config/app_config.yml"))
env_config = config[::Rails.env]
config.common.update(env_config) unless env_config.nil?
::AppConfig = OpenStruct.new(config.common)
