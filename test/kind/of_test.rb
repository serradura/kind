require 'test_helper'

class Kind::OfMethodsTest < Minitest::Test
  # --- Classes

  def test_if_the_object_is_a_kind_of_string
    err = assert_raises(Kind::Error) { Kind.of.String(:a) }
    assert_equal(':a expected to be a kind of String', err.message)

    # --

    object = 'a'

    assert_same(object, Kind.of.String(object))

    assert_equal('default', Kind.of.String(nil, or: 'default'))

    # --

    error = assert_raises(Kind::Error) { Kind.of.String(nil, or: :default) }
    assert_equal(':default expected to be a kind of String', error.message)
  end

  def test_if_the_object_is_a_kind_of_symbol
    err = assert_raises(Kind::Error) { Kind.of.Symbol('a') }
    assert_equal('"a" expected to be a kind of Symbol', err.message)

    # --

    object = :a

    assert_same(object, Kind.of.Symbol(object))

    assert_equal(:default, Kind.of.Symbol(nil, or: :default))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Symbol(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Symbol', error.message)
  end

  def test_if_the_object_is_a_kind_of_numeric
    err = assert_raises(Kind::Error) { Kind.of.Numeric('1') }
    assert_equal('"1" expected to be a kind of Numeric', err.message)

    # --

    object1 = 1
    object2 = 1.0

    assert_same(object1, Kind.of.Numeric(object1))
    assert_same(object2, Kind.of.Numeric(object2))

    assert_equal(1, Kind.of.Numeric(nil, or: 1))
    assert_equal(1.0, Kind.of.Numeric(nil, or: 1.0))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Numeric(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Numeric', error.message)
  end

  def test_if_the_object_is_a_kind_of_integer
    err = assert_raises(Kind::Error) { Kind.of.Integer(1.0) }
    assert_equal('1.0 expected to be a kind of Integer', err.message)

    # --

    object = 1

    assert_same(object, Kind.of.Integer(object))

    assert_equal(1, Kind.of.Integer(nil, or: 1))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Integer(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Integer', error.message)
  end

  def test_if_the_object_is_a_kind_of_float
    err = assert_raises(Kind::Error) { Kind.of.Float(1) }
    assert_equal('1 expected to be a kind of Float', err.message)

    # --

    object = 1.0

    assert_same(object, Kind.of.Float(object))

    assert_equal(1.0, Kind.of.Float(nil, or: 1.0))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Float(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Float', error.message)
  end

  def test_if_the_object_is_a_kind_of_regexp
    err = assert_raises(Kind::Error) { Kind.of.Regexp(1) }
    assert_equal('1 expected to be a kind of Regexp', err.message)

    # --

    object = /1.0/

    assert_same(object, Kind.of.Regexp(object))

    assert_equal(/2.0/, Kind.of.Regexp(nil, or: /2.0/))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Regexp(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Regexp', error.message)
  end

  def test_if_the_object_is_a_kind_of_time
    err = assert_raises(Kind::Error) { Kind.of.Time(1) }
    assert_equal('1 expected to be a kind of Time', err.message)

    # --

    object = Time.now

    assert_same(object, Kind.of.Time(object))

    assert_equal(object, Kind.of.Time(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Time(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Time', error.message)
  end

  def test_if_the_object_is_a_kind_of_array
    err = assert_raises(Kind::Error) { Kind.of.Array(1) }
    assert_equal('1 expected to be a kind of Array', err.message)

    # --

    object = []

    assert_same(object, Kind.of.Array(object))

    assert_equal([], Kind.of.Array(nil, or: []))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Array(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Array', error.message)
  end

  def test_if_the_object_is_a_kind_of_range
    err = assert_raises(Kind::Error) { Kind.of.Range(1) }
    assert_equal('1 expected to be a kind of Range', err.message)

    # --

    object = 1..2

    assert_same(object, Kind.of.Range(object))

    assert_equal(2..3, Kind.of.Range(nil, or: 2..3))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Range(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Range', error.message)
  end

  def test_if_the_object_is_a_kind_of_hash
    err = assert_raises(Kind::Error) { Kind.of.Hash([]) }
    assert_equal('[] expected to be a kind of Hash', err.message)

    # --

    object = { a: 1 }

    assert_same(object, Kind.of.Hash(object))

    assert_equal({}, Kind.of.Hash(nil, or: {}))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Hash(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Hash', error.message)
  end

  def test_if_the_object_is_a_kind_of_struct
    err = assert_raises(Kind::Error) { Kind.of.Struct([]) }
    assert_equal('[] expected to be a kind of Struct', err.message)

    # --

    person = Struct.new(:name)

    object = person.new('John Doe')

    assert_same(object, Kind.of.Struct(object))

    assert_equal(object, Kind.of.Struct(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Struct(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Struct', error.message)
  end

  def test_if_the_object_is_a_kind_of_enumerator
    err = assert_raises(Kind::Error) { Kind.of.Enumerator([]) }
    assert_equal('[] expected to be a kind of Enumerator', err.message)

    # --

    object = [].each

    assert_same(object, Kind.of.Enumerator(object))

    assert_equal(object, Kind.of.Enumerator(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Enumerator(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Enumerator', error.message)
  end

  def test_if_the_object_is_a_kind_of_method
    err = assert_raises(Kind::Error) { Kind.of.Method([]) }
    assert_equal('[] expected to be a kind of Method', err.message)

    # --

    object = [1,2].method(:first)

    assert_same(object, Kind.of.Method(object))

    assert_equal(object, Kind.of.Method(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Method(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Method', error.message)
  end

  def test_if_the_object_is_a_kind_of_proc
    err = assert_raises(Kind::Error) { Kind.of.Proc([]) }
    assert_equal('[] expected to be a kind of Proc', err.message)

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_same(sum, Kind.of.Proc(sum))
    assert_same(sub, Kind.of.Proc(sub))

    assert_equal(sum, Kind.of.Proc(nil, or: sum))
    assert_equal(sub, Kind.of.Proc(nil, or: sub))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Proc(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Proc', error.message)
  end

  def test_if_the_object_is_a_kind_of_file
    err = assert_raises(Kind::Error) { Kind.of.File([]) }
    assert_equal('[] expected to be a kind of File', err.message)

    object = File.new('.foo', 'w')

    assert_same(object, Kind.of.File(object))

    assert_equal(object, Kind.of.File(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.File(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of File', error.message)
  end

  def test_if_the_object_is_a_kind_of_boolean
    err = assert_raises(Kind::Error) { Kind.of.Boolean(:a) }
    assert_equal(':a expected to be a kind of Boolean', err.message)

    # --

    assert_same(true, Kind.of.Boolean(true))
    assert_same(false, Kind.of.Boolean(false))

    assert_same(true, Kind.of.Boolean(nil, or: true))
    assert_same(false, Kind.of.Boolean(nil, or: false))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Boolean(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Boolean', error.message)
  end

  def test_if_the_object_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # --

    err1 = assert_raises(Kind::Error) { Kind.of.Lambda([]) }
    assert_equal('[] expected to be a kind of Lambda', err1.message)

    err2 = assert_raises(Kind::Error) { Kind.of.Lambda(sum) }
    assert_match(/<Proc:.*> expected to be a kind of Lambda/, err2.message)

    # --

    assert_same(sub, Kind.of.Lambda(sub))

    assert_equal(sub, Kind.of.Lambda(nil, or: sub))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Lambda(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Lambda', error.message)
  end

  # --- Modules

  def test_if_the_object_is_a_kind_of_enumerable
    err = assert_raises(Kind::Error) { Kind.of.Enumerable(1) }
    assert_equal('1 expected to be a kind of Enumerable', err.message)

    object = []

    assert_same(object, Kind.of.Enumerable(object))

    assert_equal(object, Kind.of.Enumerable(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Enumerable(nil, or: 'default') }
    assert_equal('"default" expected to be a kind of Enumerable', error.message)
  end

  def test_if_the_object_is_a_kind_of_comparable
    err = assert_raises(Kind::Error) { Kind.of.Comparable([]) }
    assert_equal('[] expected to be a kind of Comparable', err.message)

    object = 'a'

    assert_same(object, Kind.of.Comparable(object))

    assert_equal(object, Kind.of.Comparable(nil, or: object))

    # --

    error = assert_raises(Kind::Error) { Kind.of.Comparable(nil, or: []) }
    assert_equal('[] expected to be a kind of Comparable', error.message)
  end
end
