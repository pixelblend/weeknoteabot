require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'

require 'mail'

lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')

$:.unshift(lib_dir)

Mail.defaults do
  delivery_method :test
end
