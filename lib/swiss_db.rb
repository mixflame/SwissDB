# SwissDB by jsilverMDX

# encoding: utf-8
unless defined?(Motion::Project::Config)
  raise "The SwissDB gem must be required within a RubyMotion project Rakefile."
end

# WHAT ARE WE?
platform = Motion::Project::App.respond_to?(:template) ? Motion::Project::App.template : :ios
if platform.to_s.start_with?('ios') or platform.to_s.start_with?('osx')
  platform_name = 'ios'
elsif platform.to_s.start_with?('android')
  platform_name = 'android'
end

# necessary for Android gem dependency as of 5/9/2015
# require "moran" if platform_name == "android"

Motion::Project::App.setup do |app|
  unless platform_name == "android"
    raise "Sorry, the platform #{platform_name} is not supported by SwissDB"
  end

  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(platform_lib, '**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end

end