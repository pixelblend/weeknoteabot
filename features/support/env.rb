require 'minitest/spec'
require 'mocha/setup'
require 'tempfile'

World(MiniTest::Assertions)
MiniTest::Spec.new(nil)
$logger = Logger.new('/dev/null')
