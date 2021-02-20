require 'test_helper'

class Kind::TypeCheckerObjectTest < Minitest::Test
  def test_the_core_checker_object_receiving_a_kind
    string_checker = Kind::TypeChecker::Object.new(::String, {})

    # FACT: Can return its kind and its name
    assert_equal(::String, string_checker.kind)
    assert_equal('String', string_checker.name)

    # FACT: Can check if a given value is an instance of its kind
    assert string_checker.instance?('foo')
    refute ['a', :b].all?(&string_checker.instance?)
    assert ['a', 'b'].all?(&string_checker.instance?)

    # FACT: Can return nil if the given value isn't an instance of its kind
    assert_equal('foo', string_checker.or_nil('foo'))
    assert_nil(string_checker.or_nil(:foo))

    # FACT: Can return Kind::Undefined if the given value isn't an instance of its kind
    assert_equal('bar', string_checker.or_undefined('bar'))
    assert_kind_undefined(string_checker.or_undefined(:foo))

    # FACT: Can return a fallback if the given value isn't an instance of its kind
    assert_equal('foo', string_checker.or(nil, 'foo'))
    assert_nil(string_checker.or(nil, :foo))

    # FACT: Can return a fallback if the given value isn't an instance of its kind
    assert_equal('foo', string_checker.or(nil, 'foo'))
    assert_nil(string_checker.or(nil, :foo))

    # FACT: Can return a callable that knows return an instance of its kind or a fallback
    assert_nil(string_checker.or(nil).call(1))
    assert_equal('foo', string_checker.or(nil).call('foo'))
    assert_equal('bar', string_checker.or('bar').(:foo))

    assert_raises_with_message(
      Kind::Error,
      ':bar expected to be a kind of String'
    ) { string_checker.or(:bar).(:foo) }

    # FACT: Can raise Kind::Error if the given value isn't an instance of its kind
    assert_equal('bar', string_checker['bar'])

    assert_raises_with_message(
      Kind::Error,
      ':bar expected to be a kind of String'
    ) { string_checker[:bar] }

    # FACT: Can return the value if it is an instance or a default if it was one too.
    assert_equal('2', string_checker.value('2', default: ''))
    assert_equal('', string_checker.value(2, default: ''))
    assert_raises_with_message(
      Kind::Error,
      '1 expected to be a kind of String'
    ) { string_checker.value(2, default: 1) }
  end

  PositiveInteger = -> value { value.kind_of?(Integer) && value > 0 }

  def test_the_core_checker_object_receiving_a_kind_name
    positive_integer_checker = Kind::TypeChecker::Object.new(PositiveInteger, name: 'PositiveInteger')

    # FACT: Can return its kind and its name
    assert_equal(PositiveInteger, positive_integer_checker.kind)
    assert_equal('PositiveInteger', positive_integer_checker.name)

    # FACT: Can check if a given value is an instance of its kind
    assert positive_integer_checker.instance?(1)
    refute positive_integer_checker.instance?(0)
    refute positive_integer_checker.instance?(-1)
    refute positive_integer_checker.instance?('1')

    refute [1, 0].all?(&positive_integer_checker.instance?)
    assert [1, 2].all?(&positive_integer_checker.instance?)

    # FACT: Can return nil if the given value isn't an instance of its kind
    assert_equal(2, positive_integer_checker.or_nil(2))
    assert_nil(positive_integer_checker.or_nil(0))
    assert_nil(positive_integer_checker.or_nil(-2))
    assert_nil(positive_integer_checker.or_nil('2'))

    # FACT: Can return Kind::Undefined if the given value isn't an instance of its kind
    assert_equal(3, positive_integer_checker.or_undefined(3))
    assert_kind_undefined(positive_integer_checker.or_undefined(0))
    assert_kind_undefined(positive_integer_checker.or_undefined(-3))
    assert_kind_undefined(positive_integer_checker.or_undefined('3'))

    # FACT: Can return a fallback if the given value isn't an instance of its kind
    assert_equal(5, positive_integer_checker.or(nil, 5))
    assert_nil(positive_integer_checker.or(nil, -1))

    # FACT: Can return a callable that knows return an instance of its kind or a fallback
    assert_equal(5, positive_integer_checker.or(nil).call(5))
    assert_equal(1, positive_integer_checker.or(1).(0))

    assert_raises_with_message(
      Kind::Error,
      '-1 expected to be a kind of PositiveInteger'
    ) { positive_integer_checker.or(-1).(0) }

    # FACT: Can raise Kind::Error if the given value isn't an instance of its kind
    assert_equal(4, positive_integer_checker[4])

    assert_raises_with_message(
      Kind::Error,
      '0 expected to be a kind of PositiveInteger'
    ) { positive_integer_checker[0] }

    # FACT: Can return the value if it is an instance or a default if it was one too.
    assert_equal(2, positive_integer_checker.value(2, default: 1))
    assert_equal(1, positive_integer_checker.value('2', default: 1))
    assert_raises_with_message(
      Kind::Error,
      '0 expected to be a kind of PositiveInteger'
    ) { positive_integer_checker.value(-1, default: 0) }
  end

  def test_the_core_checker_object_receiving_an_object_that_doesnt_have_a_name
    assert_raises_with_message(
      Kind::Error,
      'nil expected to be a kind of String'
    ) { Kind::TypeChecker::Object.new([], {}) }
  end
end