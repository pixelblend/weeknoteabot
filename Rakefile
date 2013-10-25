require 'bundler/setup'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'readline'
require 'yaml'

desc "Generates config.yml file for email"
task :config do
  config = {}
  config[:address] = Readline.readline("Address: ", true)
  config[:port] = Readline.readline("Port: ", true).to_i
  config[:user_name] = Readline.readline("Email: ", true)
  config[:password] = Readline.readline("Password: ", true)
  config[:enable_ssl] = Readline.readline("Use SSL? (y/n): ", true).downcase == 'y'

  File.open('./config.yml', 'w'){ |f| f.write(config.to_yaml) }
  puts "Written to config.yml"
end

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end
