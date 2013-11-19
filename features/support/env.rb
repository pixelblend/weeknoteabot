require 'minitest/spec'
require 'mocha/setup'
require 'tempfile'

World(MiniTest::Assertions)
MiniTest::Spec.new(nil)
$logger = Logger.new('/dev/null')

require 'contributors_cache'
ContributorsCache.stubs(:location).returns('/dev/null')
