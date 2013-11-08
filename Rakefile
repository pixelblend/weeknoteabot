require 'bundler/setup'
require 'rake/testtask'
require 'cucumber/rake/task'
require 'readline'
require 'yaml'

desc "Generates config.yml file for email"
task :config do
  puts "This task generates your config for sending and receiving email."
  puts "Sending:"
  sending = {}
  sending[:method] = Readline.readline("Method: ", true).to_sym
  sending[:address] = Readline.readline("Address: ", true)
  sending[:port] = Readline.readline("Port: ", true).to_i
  sending[:domain] = Readline.readline("Port: ", true)
  sending[:user_name] = Readline.readline("Email: ", true)
  sending[:password] = Readline.readline("Password: ", true)
  sending[:enable_start_ttls_auto] = Readline.readline("Use TTLS? (y/n): ", true).downcase == 'y'

  puts "Receiving:"
  receiving = {}
  receiving[:method] = Readline.readline("Method (imap): ", true).to_sym
  receiving[:address] = Readline.readline("Address: ", true)
  receiving[:port] = Readline.readline("Port: ", true).to_i
  receiving[:user_name] = Readline.readline("Email: ", true)
  receiving[:password] = Readline.readline("Password: ", true)
  receiving[:enable_ssl] = Readline.readline("Use SSL? (y/n): ", true).downcase == 'y'

  File.open('./config.yml', 'w'){ |f| f.write({:sending => sending, :receiving => receiving}.to_yaml) }
  puts "Written to config.yml"
end

Rake::TestTask.new do |t|
  t.pattern = "spec/**/*_spec.rb"
end

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end
task :spec => :test

task :default => [:test, :cucumber]
