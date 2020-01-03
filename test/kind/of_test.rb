require 'test_helper'

class Kind::OfMethodsTest < Minitest::Test
  # --- Classes

  def test_if_a_value_is_a_kind_of_string
    err = assert_raises(Kind::Error) { Kind.of.String(:a) }
    assert_equal(':a expected to be a kind of String', err.message)

    value = 'a'

    assert_same(value, Kind.of.String(value))
  end

  def test_if_a_value_is_a_kind_of_symbol
    err = assert_raises(Kind::Error) { Kind.of.Symbol('a') }
    assert_equal('"a" expected to be a kind of Symbol', err.message)

    value = :a

    assert_same(value, Kind.of.Symbol(value))
  end

  def test_if_a_value_is_a_kind_of_numeric
    err = assert_raises(Kind::Error) { Kind.of.Numeric('1') }
    assert_equal('"1" expected to be a kind of Numeric', err.message)

    value1 = 1
    assert_same(value1, Kind.of.Numeric(value1))

    value2 = 1.0
    assert_same(value2, Kind.of.Numeric(value2))
  end

  def test_if_a_value_is_a_kind_of_integer
    err = assert_raises(Kind::Error) { Kind.of.Integer(1.0) }
    assert_equal('1.0 expected to be a kind of Integer', err.message)

    value = 1
    assert_same(value, Kind.of.Integer(value))
  end

  def test_if_a_value_is_a_kind_of_float
    err = assert_raises(Kind::Error) { Kind.of.Float(1) }
    assert_equal('1 expected to be a kind of Float', err.message)

    value = 1.0
    assert_same(value, Kind.of.Float(value))
  end

  def test_if_a_value_is_a_kind_of_regexp
    err = assert_raises(Kind::Error) { Kind.of.Regexp(1) }
    assert_equal('1 expected to be a kind of Regexp', err.message)

    value = /1.0/
    assert_same(value, Kind.of.Regexp(value))
  end

  def test_if_a_value_is_a_kind_of_time
    err = assert_raises(Kind::Error) { Kind.of.Time(1) }
    assert_equal('1 expected to be a kind of Time', err.message)

    value = Time.now
    assert_same(value, Kind.of.Time(value))
  end

  def test_if_a_value_is_a_kind_of_array
    err = assert_raises(Kind::Error) { Kind.of.Array(1) }
    assert_equal('1 expected to be a kind of Array', err.message)

    value = []
    assert_same(value, Kind.of.Array(value))
  end

  def test_if_a_value_is_a_kind_of_range
    err = assert_raises(Kind::Error) { Kind.of.Range(1) }
    assert_equal('1 expected to be a kind of Range', err.message)

    value = 1..2
    assert_same(value, Kind.of.Range(value))
  end

  def test_if_a_value_is_a_kind_of_hash
    err = assert_raises(Kind::Error) { Kind.of.Hash([]) }
    assert_equal('[] expected to be a kind of Hash', err.message)

    value = { a: 1 }

    assert_same(value, Kind.of.Hash(value))
  end

  def test_if_a_value_is_a_kind_of_struct
    err = assert_raises(Kind::Error) { Kind.of.Struct([]) }
    assert_equal('[] expected to be a kind of Struct', err.message)

    person = Struct.new(:name)

    value = person.new('John Doe')

    assert_same(value, Kind.of.Struct(value))
  end

  def test_if_a_value_is_a_kind_of_enumerator
    err = assert_raises(Kind::Error) { Kind.of.Enumerator([]) }
    assert_equal('[] expected to be a kind of Enumerator', err.message)

    value = [].each

    assert_same(value, Kind.of.Enumerator(value))
  end

  def test_if_a_value_is_a_kind_of_method
    err = assert_raises(Kind::Error) { Kind.of.Method([]) }
    assert_equal('[] expected to be a kind of Method', err.message)

    value = [1,2].method(:first)

    assert_same(value, Kind.of.Method(value))
  end

  def test_if_a_value_is_a_kind_of_proc
    err = assert_raises(Kind::Error) { Kind.of.Proc([]) }
    assert_equal('[] expected to be a kind of Proc', err.message)

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_same(sum, Kind.of.Proc(sum))
    assert_same(sub, Kind.of.Proc(sub))
  end

  def test_if_a_value_is_a_kind_of_file
    err = assert_raises(Kind::Error) { Kind.of.File([]) }
    assert_equal('[] expected to be a kind of File', err.message)

    value = File.new('.foo', 'w')

    assert_same(value, Kind.of.File(value))
  end

  def test_if_a_value_is_a_kind_of_boolean
    err = assert_raises(Kind::Error) { Kind.of.Boolean(:a) }
    assert_equal(':a expected to be a kind of Boolean', err.message)

    assert_same(true, Kind.of.Boolean(true))
    assert_same(false, Kind.of.Boolean(false))
  end

  def test_if_a_value_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    err1 = assert_raises(Kind::Error) { Kind.of.Lambda([]) }
    assert_equal('[] expected to be a kind of Lambda', err1.message)

    err2 = assert_raises(Kind::Error) { Kind.of.Lambda(sum) }
    assert_match(/<Proc:.*> expected to be a kind of Lambda/, err2.message)

    assert_same(sub, Kind.of.Lambda(sub))
  end

  # --- Modules

  def test_if_a_value_is_a_kind_of_enumerable
    err = assert_raises(Kind::Error) { Kind.of.Enumerable(1) }
    assert_equal('1 expected to be a kind of Enumerable', err.message)

    value = []

    assert_same(value, Kind.of.Enumerable(value))
  end

  def test_if_a_value_is_a_kind_of_comparable
    err = assert_raises(Kind::Error) { Kind.of.Comparable([]) }
    assert_equal('[] expected to be a kind of Comparable', err.message)

    value = 'a'

    assert_same(value, Kind.of.Comparable(value))
  end
end
