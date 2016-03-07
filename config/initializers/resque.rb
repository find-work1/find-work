require 'resque'
require 'resque_scheduler'
require 'resque_scheduler/server'

Resque.redis = "localhost:6379"

ENV['RESQUE_WEB_HTTP_BASIC_AUTH_USER'] = "max"
ENV['RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD'] = "password"

class ResqueTest
  def perform
    `curl localhost:3000?xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
  end
end