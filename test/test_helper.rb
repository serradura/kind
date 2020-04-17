require 'simplecov'

SimpleCov.start do
  add_filter "/test/"
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "kind"

require "minitest/pride"
require "minitest/autorun"

class Minitest::Test
  def assert_raises_with_message(exception, msg, &block)
    block.call
  rescue exception => e
    assert_match(msg, e.message)
  else
    raise "Expected to raise #{exception} w/ message #{msg}, none raised"
  end

  def assert_raises_kind_error(arg, &block)
    msg =
      case arg
      when String, Regexp then arg
      when Hash then "#{arg.fetch(:given)} expected to be a kind of #{arg.fetch(:expected)}"
      else raise ArgumentError, 'argument must be a string, regexp or hash'
      end

    assert_raises_with_message(Kind::Error, msg, &block)
  end

  def assert_kind_undefined(object)
    assert_equal(Kind::Undefined, object)
  end
end
