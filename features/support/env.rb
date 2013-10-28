require 'minitest/spec'

World(MiniTest::Assertions)
MiniTest::Spec.new(nil)
$logger = Logger.new('/dev/null')
