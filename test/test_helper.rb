require 'simplecov'

SimpleCov.start do
  add_filter '/test/'
  add_filter '/lib/kind/active_model/validation.rb'

  enable_coverage :branch if RUBY_VERSION >= '2.5.0'
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'kind'

ENV.fetch('ACTIVEMODEL_VERSION', '6.1.0').tap do |active_model_version|
  if active_model_version < '6.1.0'
    require 'kind/active_model/validation'

    if active_model_version < '4.1'
      require 'minitest/unit'

      module Minitest
        Test = MiniTest::Unit::TestCase
      end
    end
  end
end

require_relative 'support/kind_is_test'

require 'minitest/pride'
require 'minitest/autorun'

class Minitest::Test
  def assert_stderr(expectation, &block)
    assert_output(nil, expectation, &block)
  end

  def assert_raises_with_message(exception, msg, &block)
    block.call
  rescue exception => e
    String === msg ? assert_equal(msg, e.message) : assert_match(msg, e.message)
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

  def assert_kind_is(expected, *valid)
    result = Array(valid).all? do |type|
      Kind::Is.public_send(expected, type) && Kind.is.public_send(expected, type)
    end

    assert(result)
  end

  def refute_kind_is(expected, *valid)
    result = Array(valid).any? do |type|
      Kind::Is.public_send(expected, type) && Kind.is.public_send(expected, type)
    end

    refute(result)
  end

  def assert_kind_checker(checker_name, options)
    # checker_name = :String

    # kind_checker_from_method = Kind.of.String
    # kind_checker_from_constant = Kind::of::Sring
    kind_checker_from_method = Kind.of.public_send(checker_name)
    kind_checker_from_constant = Kind::Of.const_get(checker_name)

    kind_name = Kind.of.String(options[:kind_name], or: checker_name.to_s) # "String"

    assert_kind_checkers(
      kind_checker_from_method,
      kind_checker_from_constant,
      options.merge(kind_name: kind_name, checker_name: checker_name)
    )
  end

  #   assert_kind_checkers(Kind.of.String,           Kind::Of::String,           {})
  def assert_kind_checkers(kind_checker_from_method, kind_checker_from_constant, options)
    # { instance: { valid: ['a', 'b'], invalid: [:a, {}] } }
    instance_data = Kind.of.Hash(options.fetch(:instance))
    valid_instances = Array(instance_data.fetch(:valid))             # ['a', 'b']
    invalid_instances = Array(instance_data.fetch(:invalid)) + [nil] # [:a, {}, nil]

    valid_instance1 = valid_instances[0]                    # 'a'
    valid_instance2 = valid_instances[1] || valid_instance1 # 'b'

    # { class: { valid: [String, Class.new(String)], invalid: [Symbol] } }
    class_or_mod_data = Kind.of.Hash(options[:class], or: options[:module])
    valid_class_or_mod = Array(class_or_mod_data.fetch(:valid))     # [String, Class.new(String)]
    invalid_class_or_mod = Array(class_or_mod_data.fetch(:invalid)) # [Symbol]

    kind_name = Kind.of.String(options.fetch(:kind_name)) # "String"
    checker_name = options.fetch(:checker_name, kind_name)

    [
      kind_checker_from_method,
      kind_checker_from_constant
    ].each do |kind_checker|
      #
      # Kind.of.<Type>.to_proc()
      #
      assert_equal(
        valid_instances.size,
        valid_instances.map(&kind_checker).size
      )

      assert_raises_kind_error(given: invalid_instances[0].inspect, expected: kind_name) do
        (valid_instances + invalid_instances).select(&kind_checker)
      end

      #
      # Kind.of.<Type>.instance()
      #
      # Kind.of.String.instance(nil) # raise Kind::Error, "nil expected to be a kind of String"
      assert_raises_kind_error(given: 'nil', expected: kind_name) { kind_checker.instance(nil) }
      # Kind.of.String.instance(Kind::Undefined) # raise Kind::Error, "Kind::Undefined expected to be a kind of String"
      assert_raises_kind_error(given: 'Kind::Undefined', expected: kind_name) { kind_checker.instance(Kind::Undefined) }

      invalid_instances.each do |invalid_instance|
        # Kind.of.String.instance(:a) # raise Kind::Error, ":a expected to be a kind of String"
        assert_raises_kind_error(given: invalid_instance.inspect, expected: kind_name) do
          kind_checker.instance(invalid_instance)
        end
      end

      valid_instances.each do |valid_instance|
        # Kind.of.String.instance('a') == 'a'
        assert_equal(valid_instance, kind_checker.instance(valid_instance))
      end
      # Kind.of.String.instance('b', or: 'a') == 'b'
      assert_equal(valid_instance2, kind_checker.instance(valid_instance2, or: valid_instance1))
      # Kind.of.String.instance(nil, or: 'a') == 'a'
      assert_equal(valid_instance1, kind_checker.instance(nil, or: valid_instance1))
      # Kind.of.String.instance(Kind::Undefined, or: 'a') == 'a'
      assert_equal(valid_instance1, kind_checker.instance(Kind::Undefined, or: valid_instance1))

      # Kind.of.String.instance(nil, or: Kind::Undefined) # raise Kind::Error, "nil expected to be a kind of String"
      assert_raises_kind_error(given: 'nil', expected: kind_name) { kind_checker.instance(nil, or: Kind::Undefined) }
      # Kind.of.String.instance(Kind::Undefined, or: nil) # raise Kind::Error, "Kind::Undefined expected to be a kind of String"
      assert_raises_kind_error(given: 'Kind::Undefined', expected: kind_name) { kind_checker.instance(Kind::Undefined, or: nil) }

      #
      # Kind.of.<Type>.instance?()
      #
      refute(invalid_instances.any? do |invalid_instance|
        # Kind.of.String.instance?(:b) == false
        kind_checker.instance?(invalid_instance)
      end)

      # Kind.of.String.instance?(:a, :b) == false
      refute(kind_checker.instance?(*invalid_instances))

      assert_equal(
        0,
        invalid_instances.select(&kind_checker.instance?).size
      )

      assert(valid_instances.all? do |valid_instance|
        # Kind.of.String.instance?('a') == true
        kind_checker.instance?(valid_instance)
      end)

      # Kind.of.String.instance?('a', 'b')
      assert(kind_checker.instance?(*valid_instances))

      assert_equal(
        valid_instances.size,
        valid_instances.select(&kind_checker.instance?).size
      )

      #
      # Kind.of.<Type>.or_nil()
      #
      # Kind.of.String.or_nil(:a) == nil
      assert_nil(kind_checker.or_nil(invalid_instances.sample))
      # Kind.of.String.or_nil('b') == 'b'
      assert_equal(valid_instance1, kind_checker.or_nil(valid_instance1))

      #
      # Kind.of.<Type>.or_undefined()
      #
      # Kind.of.String.or_undefined(:a) == Kind::Undefined
      assert_kind_undefined(kind_checker.or_undefined(invalid_instances.sample))
      # Kind.of.String.or_undefined('a') == 'a'
      assert_equal(valid_instance2, kind_checker.or_undefined(valid_instance2))

      #
      # Kind.of.<Type>.class?()
      #
      refute(invalid_class_or_mod.any? do |class_or_mod|
        # Kind.of.String.class?(Symbol) == false
        kind_checker.class?(class_or_mod)
      end)

      assert(valid_class_or_mod.all? do |class_or_mod|
        # Kind.of.String.class?(String) == true
        kind_checker.class?(class_or_mod)
      end)

      #
      # Kind.of.<Type>.as_maybe()
      #
      assert_instance_of(Kind::Maybe::None, kind_checker.as_maybe(invalid_instances.sample))

      assert(invalid_instances.map(&kind_checker.as_maybe).all?(&:none?))

      assert_instance_of(Kind::Maybe::Some, kind_checker.as_maybe(valid_instances.sample))

      assert(valid_instances.map(&kind_checker.as_maybe).all?(&:some?))

      #
      # Kind.of.<Type>.as_optional()
      #
      assert_instance_of(Kind::Optional::None, kind_checker.as_optional(invalid_instances.sample))

      assert(invalid_instances.map(&kind_checker.as_optional).all?(&:none?))

      assert_instance_of(Kind::Optional::Some, kind_checker.as_optional(valid_instances.sample))

      assert(valid_instances.map(&kind_checker.as_optional).all?(&:some?))
    end

    # Kind::Of::String === Kind.of.String
    assert_same(kind_checker_from_constant, kind_checker_from_method)

    # Kind::Of::String['a'] == Kind::Of::String.instance('a')
    kind_checker_from_constant.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([valid_instance1, {}], kind_checker_from_method[valid_instance1])
    end

    # ---

    #
    # Kind.of.<Type>?
    #
    # Kind::Of if checker_name == 'String'
    # Kind::Of::Account if checker_name == 'Account::User'
    checker_name_parts = String(checker_name).split('::')
    kind_of_scope =
      checker_name_parts[0..-2].reduce(Kind::Of) do |kind_of, name|
        kind_of.const_get(name, false)
      end

    # "String?" if checker_name == 'String'
    # "User?" if checker_name == 'Account::User'
    kind_of_is_instance = "#{checker_name_parts.last}?"

    refute(invalid_instances.any? do |invalid_instance|
      # Kind.of.String?(:b) == false
      kind_of_scope.public_send(kind_of_is_instance, invalid_instance)
    end)

    # Kind.of.String?(:a, :b) == false
    refute(kind_of_scope.public_send(kind_of_is_instance, *invalid_instances))

    assert_equal(
      0,
      invalid_instances.select(&kind_of_scope.public_send(kind_of_is_instance)).size
    )

    assert(valid_instances.all? do |valid_instance|
      # Kind.of.String?('a') == true
      kind_of_scope.public_send(kind_of_is_instance, valid_instance)
    end)

    # Kind.of.String?('a', 'b')
    assert(kind_of_scope.public_send(kind_of_is_instance, *valid_instances))

    assert_equal(
      valid_instances.size,
      valid_instances.select(&kind_of_scope.public_send(kind_of_is_instance)).size
    )
  end
end
