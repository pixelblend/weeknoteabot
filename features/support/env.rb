require 'minitest/spec'
require 'mocha/setup'

World(MiniTest::Assertions)
MiniTest::Spec.new(nil)
$logger = Logger.new('/dev/null')
