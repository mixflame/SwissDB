# coding: utf-8
$:.unshift("/Library/RubyMotion/lib")

require 'motion/project'

begin
  require 'bundler'
  require 'motion/project/template/gem/gem_tasks'
  Bundler.require
rescue LoadError
end


# require './lib/swiss_db'


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'SwissDB'
end