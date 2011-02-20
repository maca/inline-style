require 'bundler'
require "rspec/core/rake_task"

task :default => [:spec]

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

Bundler::GemHelper.install_tasks
