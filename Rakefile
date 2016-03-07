# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
Rails.application.load_tasks


# require 'resque/tasks'
# require 'resque_scheduler/tasks'

# namespace :resque do
#   task :setup do
#     require 'resque'

#     # you probably already have this somewhere
#     Resque.redis = 'localhost:6379'
#   end

#   task :setup_schedule => :setup do
#     require 'resque_scheduler'

#     Resque::Scheduler.dynamic = true

#     Resque.schedule = YAML.load_file('config/resque_schedule.yml')

#   end

#   task :scheduler => :setup_schedule
# end