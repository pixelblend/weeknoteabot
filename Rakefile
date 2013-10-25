require 'bundler/setup'
require 'rake/testtask'
require 'cucumber/rake/task'

Rake::TestTask.new do |t|
  t.pattern = "spec/*_spec.rb"
end

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end
