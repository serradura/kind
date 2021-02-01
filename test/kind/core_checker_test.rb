require 'test_helper'

class Kind::CoreCheckerTest < Minitest::Test
  def test_the_core_checker_object_receiving_a_kind
    string_checker = Kind::Core::Checker::Object.new([::String])

    assert_equal(::String, string_checker.kind)
    assert_equal('String', string_checker.name)

    assert(string_checker.instance?('foo'))

    assert_equal('foo', string_checker.or_nil('foo'))
    assert_nil(string_checker.or_nil(:foo))

    assert_equal('bar', string_checker.or_undefined('bar'))
    assert_kind_undefined(string_checker.or_undefined(:foo))

    assert_equal('bar', string_checker['bar'])

    assert_raises_with_message(
      Kind::Error,
      ':bar expected to be a kind of String'
    ) { string_checker[:bar] }
  end

  def test_the_core_checker_object_receiving_a_kind_name
    string_checker = Kind::Core::Checker::Object.new([::String, name: 'MyString'])

    assert_equal(::String, string_checker.kind)
    assert_equal('MyString', string_checker.name)
  end

  def test_the_core_checker_object_receiving_a_hash_with_the_expected_kind
    string_checker = Kind::Core::Checker::Object.new([kind: String])

    assert_equal(::String, string_checker.kind)
    assert_equal('String', string_checker.name)
  end

  PositiveInteger = -> value { value.kind_of?(Integer) && value > 0 }

  def test_the_core_checker_object_receiving_a_hash_with_the_expected_kind_and_its_name
    positive_integer_checker = Kind::Core::Checker::Object.new([{ kind: PositiveInteger, name: 'PositiveInteger' }])

    assert_equal(PositiveInteger, positive_integer_checker.kind)
    assert_equal('PositiveInteger', positive_integer_checker.name)

    assert(positive_integer_checker.instance?(1))
    refute(positive_integer_checker.instance?(0))
    refute(positive_integer_checker.instance?(-1))
    refute(positive_integer_checker.instance?('1'))

    assert_equal(2, positive_integer_checker.or_nil(2))
    assert_nil(positive_integer_checker.or_nil(0))
    assert_nil(positive_integer_checker.or_nil(-2))
    assert_nil(positive_integer_checker.or_nil('2'))

    assert_equal(3, positive_integer_checker.or_nil(3))
    assert_kind_undefined(positive_integer_checker.or_undefined(0))
    assert_kind_undefined(positive_integer_checker.or_undefined(-3))
    assert_kind_undefined(positive_integer_checker.or_undefined('3'))

    assert_equal(4, positive_integer_checker[4])

    assert_raises_with_message(
      Kind::Error,
      '0 expected to be a kind of PositiveInteger'
    ) { positive_integer_checker[0] }
  end

  def test_the_core_checker_object_receiving_a_hash_with_the_expected_kind_and_the_kind_havent_a_name
    assert_raises_with_message(
      Kind::Error,
      'nil expected to be a kind of String'
    ) { Kind::Core::Checker::Object.new([{ kind: PositiveInteger }]) }
  end

  def test_the_core_checker_object_receiving_an_empty_array
    assert_raises_with_message(
      Kind::Error,
      'nil expected to be a kind of String'
    ) { Kind::Core::Checker::Object.new([]) }
  end
end
