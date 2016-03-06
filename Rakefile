# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'resque/tasks'
require 'resque_scheduler/tasks'
Rails.application.load_tasks


namespace :resque do
  task :setup do
    require 'resque'

    # you probably already have this somewhere
    Resque.redis = 'localhost:6379'
  end

  task :setup_schedule => :setup do
    require 'resque_scheduler'

    Resque::Scheduler.dynamic = true

    Resque.schedule = YAML.load_file('config/resque_schedule.yml')

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, something like this:
    require 'jobs'
  end

  task :scheduler => :setup_schedule
end