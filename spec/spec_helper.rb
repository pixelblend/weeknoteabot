require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/setup'

lib_dir = File.join(File.dirname(__FILE__), '..', 'lib')

$:.unshift(lib_dir)
