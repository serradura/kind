require 'test_helper'

class Kind::MaybeTest < Minitest::Test
  def test_maybe_constructor
    optional = Kind::Maybe.new(0)

    assert_equal(0, Kind::Maybe.new(optional).value)
  end

  def test_maybe_result
    object = Object.new

    maybe_result = Kind::Maybe::Result.new(object)

    assert_same(object, maybe_result.value)

    assert_raises(NotImplementedError) { maybe_result.none? }
    assert_raises(NotImplementedError) { maybe_result.some? }
    assert_raises(NotImplementedError) { maybe_result.map { 0 } }
    assert_raises(NotImplementedError) { maybe_result.try(:anything) }
    assert_raises(NotImplementedError) { maybe_result.try { |value| value.anything } }
    assert_raises(NotImplementedError) { maybe_result.value_or(2) }
    assert_raises(NotImplementedError) { maybe_result.value_or { 3 } }
  end

  def test_maybe_when_some
    assert_predicate(Kind::Maybe.new(2), :some?)

    refute_predicate(Kind::Maybe.new(nil), :some?)
    refute_predicate(Kind::Maybe.new(Kind::Undefined), :some?)
  end

  def test_maybe_when_none
    assert_predicate(Kind::Maybe.new(nil), :none?)
    assert_predicate(Kind::Maybe.new(Kind::Undefined), :none?)

    refute_predicate(Kind::Maybe.new(1), :none?)
  end

  def test_maybe_value
    optional1 = Kind::Maybe.new(2)

    assert_equal(2, optional1.value)

    # ---

    optional2 = Kind::Maybe.new(nil)

    assert_nil(optional2.value)

    # ---

    optional3 = Kind::Maybe.new(Kind::Undefined)

    assert_equal(Kind::Undefined, optional3.value)
  end

  def test_maybe_value_or_default
    optional1 = Kind::Maybe.new(2)

    assert_equal(2, optional1.value_or(0))

    assert_equal(2, optional1.value_or { 0 })

    # ---

    optional2 = Kind::Maybe.new(nil)

    assert_equal(0, optional2.value_or(0))

    assert_equal(1, optional2.value_or { 1 })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { optional2.value_or }

    # ---

    optional3 = Kind::Maybe.new(Kind::Undefined)

    assert_equal(1, optional3.value_or(1))

    assert_equal(0, optional3.value_or{ 0 })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { optional3.value_or }
  end

  def test_maybe_map_when_none
    optional1 = Kind::Maybe.new(2)
    optional2 = optional1.map(&:to_s)
    optional3 = optional2.map { |value| value * 2 }

    assert_equal('2', optional2.value)
    assert_equal('22', optional3.value)

    assert_predicate(optional2, :some?)
    assert_predicate(optional3, :some?)

    refute_predicate(optional2, :none?)
    refute_predicate(optional3, :none?)

    refute_same(optional2, optional3)
  end

  def test_maybe_when_map_returns_nil
    optional1 = Kind::Maybe.new(2)
    optional2 = optional1.map { nil }
    optional3 = optional2.map { |value| value * 2 }

    assert_equal(2, optional1.value)

    assert_same(optional2, optional3)

    assert_nil(optional2.value)
    assert_nil(optional3.value)

    assert_predicate(optional2, :none?)
    assert_predicate(optional3, :none?)
  end

  def test_maybe_when_map_returns_undefined
    optional1 = Kind::Maybe.new(3)
    optional2 = optional1.map { Kind::Undefined }
    optional3 = optional2.map { |value| value * 3 }

    assert_equal(3, optional1.value)

    assert_same(optional2, optional3)

    assert_equal(Kind::Undefined, optional2.value)
    assert_equal(Kind::Undefined, optional3.value)

    assert_predicate(optional2, :none?)
    assert_predicate(optional3, :none?)
  end

  def test_maybe_constructor_alias
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe[1])

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil])
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined])
  end

  def test_then_as_an_alias_of_map
    result1 =
      Kind::Maybe[5]
        .then { |value| value * 5 }
        .then { |value| value + 17 }
        .value_or(0)

    assert_equal(42, result1)

    # ---

    result2 =
      Kind::Maybe[5]
        .then { nil }
        .value_or { 1 }

    assert_equal(1, result2)

    # ---

    result3 =
      Kind::Maybe[5]
        .then { Kind::Undefined }
        .value_or(-2)

    assert_equal(-2, result3)
  end

  def test_try_method
    assert_equal('FOO', Kind::Maybe['foo'].try(:upcase))
    assert_equal('FOO', Kind::Maybe['foo'].try { |value| value.upcase })

    assert_nil(Kind::Maybe[nil].try(:upcase))
    assert_nil(Kind::Maybe[nil].try { |value| value.upcase })

    assert_nil(Kind::Maybe[Kind::Undefined].try(:upcase))
    assert_nil(Kind::Maybe[Kind::Undefined].try { |value| value.upcase })

    assert_raises_with_message(Kind::Error, '"upcase" expected to be a kind of Symbol') do
      Kind::Maybe['foo'].try('upcase')
    end
  end

  def test_optional_is_maybe
    assert_equal(Kind::Maybe, Kind::Optional)

    # ---

    result1 =
      Kind::Optional
        .new(5)
        .map { |value| value * 5 }
        .map { |value| value - 10 }
        .value_or(0)

    assert_equal(15, result1)

    # ---

    result2 =
      Kind::Optional[5]
        .then { |value| value * 5 }
        .then { |value| value + 10 }
        .value_or { 0 }

    assert_equal(35, result2)
  end
end
