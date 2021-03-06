require 'minitest/autorun'
require 'minitest/pride'
require 'logger'

require 'mocha/setup'
require 'mail'

lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')

$:.unshift(lib_dir)

$logger = Logger.new('/dev/null')

Mail.defaults do
  delivery_method :test
end

require 'contributors_cache'
require 'weeknote_state_cache'
require 'weeknote_submissions_cache'
def ContributorsCache.location; '/dev/null'; end
def WeeknoteStateCache.location; '/dev/null'; end
def WeeknoteSubmissionsCache.write(data); end
