require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server

Redque.redis = "localhost:6379"

ENV['RESQUE_WEB_HTTP_BASIC_AUTH_USER'] = "max"
ENV['RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD'] = "password"
