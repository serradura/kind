require 'test_helper'

class Kind::OfCheckersTest < Minitest::Test
  # -- Classes

  def test_if_a_value_is_a_kind_of_class
    assert_raises_kind_error(given: 'nil', expected: 'Class') { Kind.of.Class.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Class') { Kind.of.Class.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Class') { Kind.of.Class.instance(:a) }
    assert_raises_kind_error(given: 'Enumerable', expected: 'Class') { Kind.of.Class.instance(Enumerable) }
    assert_equal(String, Kind.of.Class.instance(String))
    assert_equal(Symbol, Kind.of.Class.instance(Symbol, or: String))
    assert_equal(String, Kind.of.Class.instance(nil, or: String))
    assert_equal(String, Kind.of.Class.instance(Kind::Undefined, or: String))
    assert_raises_kind_error(given: 'nil', expected: 'Class') { Kind.of.Class.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Class') { Kind.of.Class.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Class.instance?([1])
    refute Kind.of.Class.instance?(Enumerable)
    assert Kind.of.Class.instance?(String)

    assert Kind.of.Class.class?(String)
    assert Kind.of.Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })
    refute Kind.of.Class.class?(Enumerable)

    assert_nil Kind.of.Class.or_nil('')
    assert_equal(String, Kind.of.Class.or_nil(String))

    assert_kind_undefined Kind.of.Class.or_undefined('')
    assert_equal(String, Kind.of.Class.or_undefined(String))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Class') { Kind::Of::Class.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Class') { Kind::Of::Class.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Class') { Kind::Of::Class.instance(:a) }
    assert_raises_kind_error(given: 'Enumerable', expected: 'Class') { Kind::Of::Class.instance(Enumerable) }
    assert_equal(String, Kind::Of::Class.instance(String))
    assert_equal(Symbol, Kind::Of::Class.instance(Symbol, or: String))
    assert_equal(String, Kind::Of::Class.instance(nil, or: String))
    assert_equal(String, Kind::Of::Class.instance(Kind::Undefined, or: String))
    assert_raises_kind_error(given: 'nil', expected: 'Class') { Kind::Of::Class.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Class') { Kind::Of::Class.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Class.instance?([1])
    refute Kind::Of::Class.instance?(Enumerable)
    assert Kind::Of::Class.instance?(String)

    assert Kind::Of::Class.class?(String)
    assert Kind::Of::Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })
    refute Kind::Of::Class.class?(Enumerable)

    assert_nil Kind::Of::Class.or_nil('')
    assert_equal(String, Kind::Of::Class.or_nil(String))

    assert_kind_undefined Kind::Of::Class.or_undefined('')
    assert_equal(String, Kind::Of::Class.or_undefined(String))

    # --

    assert_same(Kind::Of::Class, Kind.of.Class)

    Kind::Of::Class.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([String, {}], Kind.of.Class[String])
    end
  end

  # --- String

  def test_if_a_value_is_a_kind_of_string
    assert_raises_kind_error(given: 'nil', expected: 'String') { Kind.of.String.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'String') { Kind.of.String.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'String') { Kind.of.String.instance(:a) }
    assert_equal('a', Kind.of.String.instance('a'))
    assert_equal('b', Kind.of.String.instance(:a, or: 'b'))
    assert_equal('c', Kind.of.String.instance(nil, or: 'c'))
    assert_equal('d', Kind.of.String.instance(Kind::Undefined, or: 'd'))
    assert_raises_kind_error(given: 'nil', expected: 'String') { Kind.of.String.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'String') { Kind.of.String.instance(Kind::Undefined, or: nil) }

    refute Kind.of.String.instance?({})
    assert Kind.of.String.instance?('')

    assert_equal(false, Kind.of.String.class?(Hash))
    assert_equal(true, Kind.of.String.class?(String))
    assert_equal(true, Kind.of.String.class?(Class.new(String)))

    assert_nil Kind.of.String.or_nil({})
    assert_equal('a', Kind.of.String.or_nil('a'))

    assert_kind_undefined Kind.of.String.or_undefined({})
    assert_equal('a', Kind.of.String.or_undefined('a'))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'String') { Kind::Of::String.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'String') { Kind::Of::String.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'String') { Kind::Of::String.instance(:a) }
    assert_equal('a', Kind::Of::String.instance('a'))
    assert_equal('b', Kind::Of::String.instance(:a, or: 'b'))
    assert_equal('c', Kind::Of::String.instance(nil, or: 'c'))
    assert_equal('d', Kind::Of::String.instance(Kind::Undefined, or: 'd'))
    assert_raises_kind_error(given: 'nil', expected: 'String') { Kind::Of::String.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'String') { Kind::Of::String.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::String.instance?({})
    assert Kind::Of::String.instance?('')

    refute Kind::Of::String.class?(Hash)
    assert Kind::Of::String.class?(String)
    assert Kind::Of::String.class?(Class.new(String))

    assert_nil Kind::Of::String.or_nil({})
    assert_equal('a', Kind::Of::String.or_nil('a'))

    assert_kind_undefined Kind::Of::String.or_undefined({})
    assert_equal('a', Kind::Of::String.or_undefined('a'))

    # --

    assert_same(Kind::Of::String, Kind.of.String)

    Kind::Of::String.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal(['a', {}], Kind.of.String['a'])
    end
  end

  # --- Symbol

  def test_if_a_value_is_a_kind_of_symbol
    assert_raises_kind_error(given: 'nil', expected: 'Symbol') { Kind.of.Symbol.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Symbol') { Kind.of.Symbol.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Symbol') { Kind.of.Symbol.instance(1) }
    assert_equal(:a, Kind.of.Symbol.instance(:a))
    assert_equal(:b, Kind.of.Symbol.instance('a', or: :b))
    assert_equal(:c, Kind.of.Symbol.instance(nil, or: :c))
    assert_equal(:d, Kind.of.Symbol.instance(Kind::Undefined, or: :d))
    assert_raises_kind_error(given: 'nil', expected: 'Symbol') { Kind.of.Symbol.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Symbol') { Kind.of.Symbol.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Symbol.instance?({})
    assert Kind.of.Symbol.instance?(:a)

    refute Kind.of.Symbol.class?(Hash)
    assert Kind.of.Symbol.class?(Symbol)
    assert Kind.of.Symbol.class?(Class.new(Symbol))

    assert_nil Kind.of.Symbol.or_nil({})
    assert_equal(:a, Kind.of.Symbol.or_nil(:a))

    assert_kind_undefined Kind.of.Symbol.or_undefined({})
    assert_equal(:a, Kind.of.Symbol.or_undefined(:a))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Symbol') { Kind::Of::Symbol.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Symbol') { Kind::Of::Symbol.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Symbol') { Kind::Of::Symbol.instance(1) }
    assert_equal(:a, Kind::Of::Symbol.instance(:a))
    assert_equal(:b, Kind::Of::Symbol.instance('a', or: :b))
    assert_equal(:c, Kind::Of::Symbol.instance(nil, or: :c))
    assert_equal(:d, Kind::Of::Symbol.instance(Kind::Undefined, or: :d))
    assert_raises_kind_error(given: 'nil', expected: 'Symbol') { Kind::Of::Symbol.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Symbol') { Kind::Of::Symbol.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Symbol.instance?({})
    assert Kind::Of::Symbol.instance?(:a)

    refute Kind::Of::Symbol.class?(Hash)
    assert Kind::Of::Symbol.class?(Symbol)
    assert Kind::Of::Symbol.class?(Class.new(Symbol))

    assert_nil Kind::Of::Symbol.or_nil({})
    assert_equal(:a, Kind::Of::Symbol.or_nil(:a))

    assert_kind_undefined Kind::Of::Symbol.or_undefined({})
    assert_equal(:a, Kind::Of::Symbol.or_undefined(:a))

    # --

    assert_same(Kind::Of::Symbol, Kind.of.Symbol)

    Kind::Of::Symbol.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([:a, {}], Kind.of.Symbol[:a])
    end
  end

  # --- Numeric

  def test_if_a_value_is_a_kind_of_numeric
    assert_raises_kind_error(given: 'nil', expected: 'Numeric') { Kind.of.Numeric.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Numeric') { Kind.of.Numeric.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Numeric') { Kind.of.Numeric.instance(:a) }
    assert_equal(1, Kind.of.Numeric.instance(1))
    assert_equal(1.0, Kind.of.Numeric.instance('a', or: 1.0))
    assert_equal(2, Kind.of.Numeric.instance(nil, or: 2))
    assert_equal(3.0, Kind.of.Numeric.instance(Kind::Undefined, or: 3.0))
    assert_raises_kind_error(given: 'nil', expected: 'Numeric') { Kind.of.Numeric.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Numeric') { Kind.of.Numeric.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Numeric.instance?({})
    assert Kind.of.Numeric.instance?(1)
    assert Kind.of.Numeric.instance?(1.0)

    refute Kind.of.Numeric.class?(Hash)
    assert Kind.of.Numeric.class?(Numeric)
    assert Kind.of.Numeric.class?(Integer)
    assert Kind.of.Numeric.class?(Float)
    assert Kind.of.Numeric.class?(Class.new(Numeric))

    assert_nil Kind.of.Numeric.or_nil({})
    assert_equal(1, Kind.of.Numeric.or_nil(1))
    assert_equal(1.0, Kind.of.Numeric.or_nil(1.0))

    assert_kind_undefined Kind.of.Numeric.or_undefined({})
    assert_equal(1, Kind.of.Numeric.or_undefined(1))
    assert_equal(1.0, Kind.of.Numeric.or_undefined(1.0))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Numeric') { Kind::Of::Numeric.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Numeric') { Kind::Of::Numeric.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Numeric') { Kind::Of::Numeric.instance(:a) }
    assert_equal(1, Kind::Of::Numeric.instance(1))
    assert_equal(1.0, Kind::Of::Numeric.instance('a', or: 1.0))
    assert_equal(2, Kind::Of::Numeric.instance(nil, or: 2))
    assert_equal(3.0, Kind::Of::Numeric.instance(Kind::Undefined, or: 3.0))
    assert_raises_kind_error(given: 'nil', expected: 'Numeric') { Kind::Of::Numeric.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Numeric') { Kind::Of::Numeric.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Numeric.instance?({})
    assert Kind::Of::Numeric.instance?(1)
    assert Kind::Of::Numeric.instance?(1.0)

    refute Kind::Of::Numeric.class?(Hash)
    assert Kind::Of::Numeric.class?(Numeric)
    assert Kind::Of::Numeric.class?(Integer)
    assert Kind::Of::Numeric.class?(Float)
    assert Kind::Of::Numeric.class?(Class.new(Numeric))

    assert_nil Kind::Of::Numeric.or_nil({})
    assert_equal(1, Kind::Of::Numeric.or_nil(1))
    assert_equal(1.0, Kind::Of::Numeric.or_nil(1.0))

    assert_kind_undefined Kind::Of::Numeric.or_undefined({})
    assert_equal(1, Kind::Of::Numeric.or_undefined(1))
    assert_equal(1.0, Kind::Of::Numeric.or_undefined(1.0))

    # --

    assert_same(Kind::Of::Numeric, Kind.of.Numeric)

    Kind::Of::Numeric.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([1, {}], Kind.of.Numeric[1])
    end
  end

  # --- Integer

  def test_if_a_value_is_a_kind_of_integer
    assert_raises_kind_error(given: 'nil', expected: 'Integer') { Kind.of.Integer.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Integer') { Kind.of.Integer.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1.0', expected: 'Integer') { Kind.of.Integer.instance(1.0) }
    assert_equal(1, Kind.of.Integer.instance(1))
    assert_equal(2, Kind.of.Integer.instance(nil, or: 2))
    assert_equal(3, Kind.of.Integer.instance(3.0, or: 3))
    assert_equal(4, Kind.of.Integer.instance(Kind::Undefined, or: 4))
    assert_raises_kind_error(given: 'nil', expected: 'Integer') { Kind.of.Integer.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Integer') { Kind.of.Integer.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Integer.instance?({})
    assert Kind.of.Integer.instance?(1)

    refute Kind.of.Integer.class?(Hash)
    assert Kind.of.Integer.class?(Integer)
    assert Kind.of.Integer.class?(Class.new(Integer))

    assert_nil Kind.of.Integer.or_nil({})
    assert_nil Kind.of.Integer.or_nil(1.0)
    assert_equal(1, Kind.of.Integer.or_nil(1))

    assert_kind_undefined Kind.of.Integer.or_undefined({})
    assert_kind_undefined Kind.of.Integer.or_undefined(1.0)
    assert_equal(1, Kind.of.Integer.or_undefined(1))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Integer') { Kind::Of::Integer.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Integer') { Kind::Of::Integer.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1.0', expected: 'Integer') { Kind::Of::Integer.instance(1.0) }
    assert_equal(1, Kind::Of::Integer.instance(1))
    assert_equal(2, Kind::Of::Integer.instance(nil, or: 2))
    assert_equal(3, Kind::Of::Integer.instance(3.0, or: 3))
    assert_equal(4, Kind::Of::Integer.instance(Kind::Undefined, or: 4))
    assert_raises_kind_error(given: 'nil', expected: 'Integer') { Kind::Of::Integer.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Integer') { Kind::Of::Integer.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Integer.instance?({})
    assert Kind::Of::Integer.instance?(1)

    refute Kind::Of::Integer.class?(Hash)
    assert Kind::Of::Integer.class?(Integer)
    assert Kind::Of::Integer.class?(Class.new(Integer))

    assert_nil Kind::Of::Integer.or_nil({})
    assert_nil Kind::Of::Integer.or_nil(1.0)
    assert_equal(1, Kind::Of::Integer.or_nil(1))

    assert_kind_undefined Kind::Of::Integer.or_undefined({})
    assert_kind_undefined Kind::Of::Integer.or_undefined(1.0)
    assert_equal(1, Kind::Of::Integer.or_undefined(1))

    # --

    assert_same(Kind::Of::Integer, Kind.of.Integer)

    Kind::Of::Integer.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([1, {}], Kind.of.Integer[1])
    end
  end

  # --- Float

  def test_if_a_value_is_a_kind_of_Float
    assert_raises_kind_error(given: 'nil', expected: 'Float') { Kind.of.Float.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Float') { Kind.of.Float.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Float') { Kind.of.Float.instance(1) }
    assert_equal(1.0, Kind.of.Float.instance(1.0))
    assert_equal(2.0, Kind.of.Float.instance(nil, or: 2.0))
    assert_equal(3.0, Kind.of.Float.instance(3, or: 3.0))
    assert_equal(4.0, Kind.of.Float.instance(Kind::Undefined, or: 4.0))
    assert_raises_kind_error(given: 'nil', expected: 'Float') { Kind.of.Float.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Float') { Kind.of.Float.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Float.instance?({})
    assert Kind.of.Float.instance?(1.0)

    refute Kind.of.Float.class?(Hash)
    assert Kind.of.Float.class?(Float)
    assert Kind.of.Float.class?(Class.new(Float))

    assert_nil Kind.of.Float.or_nil({})
    assert_nil Kind.of.Float.or_nil(1)
    assert_equal(1.0, Kind.of.Float.or_nil(1.0))

    assert_kind_undefined Kind.of.Float.or_undefined({})
    assert_kind_undefined Kind.of.Float.or_undefined(1)
    assert_equal(1.0, Kind.of.Float.or_undefined(1.0))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Float') { Kind::Of::Float.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Float') { Kind::Of::Float.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Float') { Kind::Of::Float.instance(1) }
    assert_equal(1.0, Kind::Of::Float.instance(1.0))
    assert_equal(2.0, Kind::Of::Float.instance(nil, or: 2.0))
    assert_equal(3.0, Kind::Of::Float.instance(3, or: 3.0))
    assert_equal(4.0, Kind::Of::Float.instance(Kind::Undefined, or: 4.0))
    assert_raises_kind_error(given: 'nil', expected: 'Float') { Kind::Of::Float.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Float') { Kind::Of::Float.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Float.instance?({})
    assert Kind::Of::Float.instance?(1.0)

    refute Kind::Of::Float.class?(Hash)
    assert Kind::Of::Float.class?(Float)
    assert Kind::Of::Float.class?(Class.new(Float))

    assert_nil Kind::Of::Float.or_nil({})
    assert_nil Kind::Of::Float.or_nil(1)
    assert_equal(1.0, Kind::Of::Float.or_nil(1.0))

    assert_kind_undefined Kind::Of::Float.or_undefined({})
    assert_kind_undefined Kind::Of::Float.or_undefined(1)
    assert_equal(1.0, Kind::Of::Float.or_undefined(1.0))

    # --

    assert_same(Kind::Of::Float, Kind.of.Float)

    Kind::Of::Float.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([1.0, {}], Kind.of.Float[1.0])
    end
  end

  # --- Regexp

  def test_if_a_value_is_a_kind_of_regexp
    assert_raises_kind_error(given: 'nil', expected: 'Regexp') { Kind.of.Regexp.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Regexp') { Kind.of.Regexp.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Regexp') { Kind.of.Regexp.instance(1) }
    assert_equal(/1.0/, Kind.of.Regexp.instance(/1.0/))
    assert_equal(/1.0/, Kind.of.Regexp.instance(nil, or: /1.0/))
    assert_equal(/1.0/, Kind.of.Regexp.instance(3, or: /1.0/))
    assert_equal(/1.0/, Kind.of.Regexp.instance(Kind::Undefined, or: /1.0/))
    assert_raises_kind_error(given: 'nil', expected: 'Regexp') { Kind.of.Regexp.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Regexp') { Kind.of.Regexp.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Regexp.instance?({})
    assert Kind.of.Regexp.instance?(/1.0/)

    refute Kind.of.Regexp.class?(Hash)
    assert Kind.of.Regexp.class?(Regexp)
    assert Kind.of.Regexp.class?(Class.new(Regexp))

    assert_nil Kind.of.Regexp.or_nil({})
    assert_equal(/1.0/, Kind.of.Regexp.or_nil(/1.0/))

    assert_kind_undefined Kind.of.Regexp.or_undefined({})
    assert_equal(/1.0/, Kind.of.Regexp.or_undefined(/1.0/))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Regexp') { Kind::Of::Regexp.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Regexp') { Kind::Of::Regexp.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Regexp') { Kind::Of::Regexp.instance(1) }
    assert_equal(/1.0/, Kind::Of::Regexp.instance(/1.0/))
    assert_equal(/1.0/, Kind::Of::Regexp.instance(nil, or: /1.0/))
    assert_equal(/1.0/, Kind::Of::Regexp.instance(3, or: /1.0/))
    assert_equal(/1.0/, Kind::Of::Regexp.instance(Kind::Undefined, or: /1.0/))
    assert_raises_kind_error(given: 'nil', expected: 'Regexp') { Kind::Of::Regexp.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Regexp') { Kind::Of::Regexp.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Regexp.instance?({})
    assert Kind::Of::Regexp.instance?(/1.0/)

    refute Kind::Of::Regexp.class?(Hash)
    assert Kind::Of::Regexp.class?(Regexp)
    assert Kind::Of::Regexp.class?(Class.new(Regexp))

    assert_nil Kind::Of::Regexp.or_nil({})
    assert_equal(/1.0/, Kind::Of::Regexp.or_nil(/1.0/))

    assert_kind_undefined Kind::Of::Regexp.or_undefined({})
    assert_equal(/1.0/, Kind::Of::Regexp.or_undefined(/1.0/))

    # --

    assert_same(Kind::Of::Regexp, Kind.of.Regexp)

    Kind::Of::Regexp.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([/1.0/, {}], Kind.of.Regexp[/1.0/])
    end
  end

  # --- Time

  def test_if_a_value_is_a_kind_of_time
    now = Time.now

    assert_raises_kind_error(given: 'nil', expected: 'Time') { Kind.of.Time.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Time') { Kind.of.Time.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Time') { Kind.of.Time.instance(1) }
    assert_equal(now, Kind.of.Time.instance(now))
    assert_equal(now, Kind.of.Time.instance(nil, or: now))
    assert_equal(now, Kind.of.Time.instance(3, or: now))
    assert_equal(now, Kind.of.Time.instance(Kind::Undefined, or: now))
    assert_raises_kind_error(given: 'nil', expected: 'Time') { Kind.of.Time.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Time') { Kind.of.Time.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Time.instance?({})
    assert Kind.of.Time.instance?(now)

    refute Kind.of.Time.class?(Hash)
    assert Kind.of.Time.class?(Time)
    assert Kind.of.Time.class?(Class.new(Time))

    assert_nil Kind.of.Time.or_nil({})
    assert_equal(now, Kind.of.Time.or_nil(now))

    assert_kind_undefined Kind.of.Time.or_undefined({})
    assert_equal(now, Kind.of.Time.or_undefined(now))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Time') { Kind::Of::Time.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Time') { Kind::Of::Time.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Time') { Kind::Of::Time.instance(1) }
    assert_equal(now, Kind::Of::Time.instance(now))
    assert_equal(now, Kind::Of::Time.instance(nil, or: now))
    assert_equal(now, Kind::Of::Time.instance(3, or: now))
    assert_equal(now, Kind::Of::Time.instance(Kind::Undefined, or: now))
    assert_raises_kind_error(given: 'nil', expected: 'Time') { Kind::Of::Time.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Time') { Kind::Of::Time.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Time.instance?({})
    assert Kind::Of::Time.instance?(now)

    refute Kind::Of::Time.class?(Hash)
    assert Kind::Of::Time.class?(Time)
    assert Kind::Of::Time.class?(Class.new(Time))

    assert_nil Kind::Of::Time.or_nil({})
    assert_equal(now, Kind::Of::Time.or_nil(now))

    assert_kind_undefined Kind::Of::Time.or_undefined({})
    assert_equal(now, Kind::Of::Time.or_undefined(now))

    # --

    assert_same(Kind::Of::Time, Kind.of.Time)

    Kind::Of::Time.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([now, {}], Kind.of.Time[now])
    end
  end

  # --- Array

  def test_if_a_value_is_a_kind_of_array
    assert_raises_kind_error(given: 'nil', expected: 'Array') { Kind.of.Array.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Array') { Kind.of.Array.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Array') { Kind.of.Array.instance(1) }
    assert_equal([], Kind.of.Array.instance([]))
    assert_equal([], Kind.of.Array.instance(nil, or: []))
    assert_equal([], Kind.of.Array.instance(3, or: []))
    assert_equal([], Kind.of.Array.instance(Kind::Undefined, or: []))
    assert_raises_kind_error(given: 'nil', expected: 'Array') { Kind.of.Array.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Array') { Kind.of.Array.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Array.instance?({})
    assert Kind.of.Array.instance?([])

    assert Kind.of.Array.class?(Array)
    assert Kind.of.Array.class?(Class.new(Array))

    assert_nil Kind.of.Array.or_nil({})
    assert_equal([1], Kind.of.Array.or_nil([1]))

    assert_kind_undefined Kind.of.Array.or_undefined({})
    assert_equal([2], Kind.of.Array.or_undefined([2]))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Array') { Kind::Of::Array.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Array') { Kind::Of::Array.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Array') { Kind::Of::Array.instance(1) }
    assert_equal([], Kind::Of::Array.instance([]))
    assert_equal([], Kind::Of::Array.instance(nil, or: []))
    assert_equal([], Kind::Of::Array.instance(3, or: []))
    assert_equal([], Kind::Of::Array.instance(Kind::Undefined, or: []))
    assert_raises_kind_error(given: 'nil', expected: 'Array') { Kind::Of::Array.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Array') { Kind::Of::Array.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Array.instance?({})
    assert Kind::Of::Array.instance?([])

    refute Kind::Of::Array.class?(Hash)
    assert Kind::Of::Array.class?(Array)
    assert Kind::Of::Array.class?(Class.new(Array))

    assert_nil Kind::Of::Array.or_nil({})
    assert_equal([1], Kind::Of::Array.or_nil([1]))

    assert_kind_undefined Kind::Of::Array.or_undefined({})
    assert_equal([2], Kind::Of::Array.or_undefined([2]))

    # --

    assert_same(Kind::Of::Array, Kind.of.Array)

    Kind::Of::Array.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([[1], {}], Kind.of.Array[[1]])
    end
  end

  # --- Range

  def test_if_a_value_is_a_kind_of_range
    range = 1..2

    assert_raises_kind_error(given: 'nil', expected: 'Range') { Kind.of.Range.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Range') { Kind.of.Range.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Range') { Kind.of.Range.instance(1) }
    assert_equal(range, Kind.of.Range.instance(range))
    assert_equal(range, Kind.of.Range.instance(nil, or: range))
    assert_equal(range, Kind.of.Range.instance(3, or: range))
    assert_equal(range, Kind.of.Range.instance(Kind::Undefined, or: range))
    assert_raises_kind_error(given: 'nil', expected: 'Range') { Kind.of.Range.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Range') { Kind.of.Range.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Range.instance?({})
    assert Kind.of.Range.instance?(range)

    assert Kind.of.Range.class?(Range)
    assert Kind.of.Range.class?(Class.new(Range))

    assert_nil Kind.of.Range.or_nil({})
    assert_equal(range, Kind.of.Range.or_nil(range))

    assert_kind_undefined Kind.of.Range.or_undefined({})
    assert_equal(range, Kind.of.Range.or_undefined(range))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Range') { Kind::Of::Range.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Range') { Kind::Of::Range.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Range') { Kind::Of::Range.instance(1) }
    assert_equal(range, Kind::Of::Range.instance(range))
    assert_equal(range, Kind::Of::Range.instance(nil, or: range))
    assert_equal(range, Kind::Of::Range.instance(3, or: range))
    assert_equal(range, Kind::Of::Range.instance(Kind::Undefined, or: range))
    assert_raises_kind_error(given: 'nil', expected: 'Range') { Kind::Of::Range.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Range') { Kind::Of::Range.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Range.instance?({})
    assert Kind::Of::Range.instance?(range)

    refute Kind::Of::Range.class?(Hash)
    assert Kind::Of::Range.class?(Range)
    assert Kind::Of::Range.class?(Class.new(Range))

    assert_nil Kind::Of::Range.or_nil({})
    assert_equal(range, Kind::Of::Range.or_nil(range))

    assert_kind_undefined Kind::Of::Range.or_undefined({})
    assert_equal(range, Kind::Of::Range.or_undefined(range))

    # --

    assert_same(Kind::Of::Range, Kind.of.Range)

    Kind::Of::Range.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([range, {}], Kind.of.Range[range])
    end
  end

  # --- Hash

  def test_if_a_value_is_a_kind_of_hash
    assert_raises_kind_error(given: 'nil', expected: 'Hash') { Kind.of.Hash.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Hash') { Kind.of.Hash.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Hash') { Kind.of.Hash.instance(1) }
    assert_equal({}, Kind.of.Hash.instance({}))
    assert_equal({}, Kind.of.Hash.instance(nil, or: {}))
    assert_equal({}, Kind.of.Hash.instance(3, or: {}))
    assert_equal({}, Kind.of.Hash.instance(Kind::Undefined, or: {}))
    assert_raises_kind_error(given: 'nil', expected: 'Hash') { Kind.of.Hash.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Hash') { Kind.of.Hash.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Hash.instance?('')
    assert Kind.of.Hash.instance?({})

    assert Kind.of.Hash.class?(Hash)
    assert Kind.of.Hash.class?(Class.new(Hash))

    assert_nil Kind.of.Hash.or_nil('')
    assert_equal({a: 1}, Kind.of.Hash.or_nil(a: 1))

    assert_kind_undefined Kind.of.Hash.or_undefined([])
    assert_equal({b: 2}, Kind.of.Hash.or_undefined({b: 2}))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Hash') { Kind::Of::Hash.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Hash') { Kind::Of::Hash.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Hash') { Kind::Of::Hash.instance(1) }
    assert_equal({}, Kind::Of::Hash.instance({}))
    assert_equal({}, Kind::Of::Hash.instance(nil, or: {}))
    assert_equal({}, Kind::Of::Hash.instance(3, or: {}))
    assert_equal({}, Kind::Of::Hash.instance(Kind::Undefined, or: {}))
    assert_raises_kind_error(given: 'nil', expected: 'Hash') { Kind::Of::Hash.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Hash') { Kind::Of::Hash.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Hash.instance?('')
    assert Kind::Of::Hash.instance?({})

    refute Kind::Of::Hash.class?(String)
    assert Kind::Of::Hash.class?(Hash)
    assert Kind::Of::Hash.class?(Class.new(Hash))

    assert_nil Kind::Of::Hash.or_nil('')
    assert_equal({a: 1}, Kind::Of::Hash.or_nil(a: 1))

    assert_kind_undefined Kind::Of::Hash.or_undefined([])
    assert_equal({b: 2}, Kind::Of::Hash.or_undefined({b: 2}))

    # --

    assert_same(Kind::Of::Hash, Kind.of.Hash)

    Kind::Of::Hash.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([{c: 3}, {}], Kind.of.Hash[{c: 3}])
    end
  end

  # --- Struct

  def test_if_a_value_is_a_kind_of_struct
    struct = Struct.new(:name)
    person = struct.new('John Doe')

    assert_raises_kind_error(given: 'nil', expected: 'Struct') { Kind.of.Struct.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Struct') { Kind.of.Struct.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Struct') { Kind.of.Struct.instance(1) }
    assert_equal(person, Kind.of.Struct.instance(person))
    assert_equal(person, Kind.of.Struct.instance(nil, or: person))
    assert_equal(person, Kind.of.Struct.instance(3, or: person))
    assert_equal(person, Kind.of.Struct.instance(Kind::Undefined, or: person))
    assert_raises_kind_error(given: 'nil', expected: 'Struct') { Kind.of.Struct.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Struct') { Kind.of.Struct.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Struct.instance?({})
    assert Kind.of.Struct.instance?(person)

    assert Kind.of.Struct.class?(Struct)
    assert Kind.of.Struct.class?(Class.new(Struct))

    assert_nil Kind.of.Struct.or_nil('')
    assert_equal(person, Kind.of.Struct.or_nil(person))

    assert_kind_undefined Kind.of.Struct.or_undefined([])
    assert_equal(person, Kind.of.Struct.or_undefined(person))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Struct') { Kind::Of::Struct.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Struct') { Kind::Of::Struct.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Struct') { Kind::Of::Struct.instance(1) }
    assert_equal(person, Kind::Of::Struct.instance(person))
    assert_equal(person, Kind::Of::Struct.instance(nil, or: person))
    assert_equal(person, Kind::Of::Struct.instance(3, or: person))
    assert_equal(person, Kind::Of::Struct.instance(Kind::Undefined, or: person))
    assert_raises_kind_error(given: 'nil', expected: 'Struct') { Kind::Of::Struct.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Struct') { Kind::Of::Struct.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Struct.instance?('')
    assert Kind::Of::Struct.instance?(person)

    refute Kind::Of::Struct.class?(String)
    assert Kind::Of::Struct.class?(Struct)
    assert Kind::Of::Struct.class?(Class.new(Struct))

    assert_nil Kind::Of::Struct.or_nil('')
    assert_equal(person, Kind::Of::Struct.or_nil(person))

    assert_kind_undefined Kind::Of::Struct.or_undefined([])
    assert_equal(person, Kind::Of::Struct.or_undefined(person))

    # --

    assert_same(Kind::Of::Struct, Kind.of.Struct)

    Kind::Of::Struct.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([person, {}], Kind.of.Struct[person])
    end
  end

  # --- Enumerator

  def test_if_a_value_is_a_kind_of_enumerator
    enumerator = [].each

    assert_raises_kind_error(given: 'nil', expected: 'Enumerator') { Kind.of.Enumerator.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerator') { Kind.of.Enumerator.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Enumerator') { Kind.of.Enumerator.instance(1) }
    assert_equal(enumerator, Kind.of.Enumerator.instance(enumerator))
    assert_equal(enumerator, Kind.of.Enumerator.instance(nil, or: enumerator))
    assert_equal(enumerator, Kind.of.Enumerator.instance(3, or: enumerator))
    assert_equal(enumerator, Kind.of.Enumerator.instance(Kind::Undefined, or: enumerator))
    assert_raises_kind_error(given: 'nil', expected: 'Enumerator') { Kind.of.Enumerator.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerator') { Kind.of.Enumerator.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Enumerator.instance?({})
    assert Kind.of.Enumerator.instance?(enumerator)

    assert Kind.of.Enumerator.class?(Enumerator)
    assert Kind.of.Enumerator.class?(Class.new(Enumerator))

    assert_nil Kind.of.Enumerator.or_nil('')
    assert_equal(enumerator, Kind.of.Enumerator.or_nil(enumerator))

    assert_kind_undefined Kind.of.Enumerator.or_undefined([])
    assert_equal(enumerator, Kind.of.Enumerator.or_undefined(enumerator))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Enumerator') { Kind::Of::Enumerator.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerator') { Kind::Of::Enumerator.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Enumerator') { Kind::Of::Enumerator.instance(1) }
    assert_equal(enumerator, Kind::Of::Enumerator.instance(enumerator))
    assert_equal(enumerator, Kind::Of::Enumerator.instance(nil, or: enumerator))
    assert_equal(enumerator, Kind::Of::Enumerator.instance(3, or: enumerator))
    assert_equal(enumerator, Kind::Of::Enumerator.instance(Kind::Undefined, or: enumerator))
    assert_raises_kind_error(given: 'nil', expected: 'Enumerator') { Kind::Of::Enumerator.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerator') { Kind::Of::Enumerator.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Enumerator.instance?('')
    assert Kind::Of::Enumerator.instance?(enumerator)

    refute Kind::Of::Enumerator.class?(String)
    assert Kind::Of::Enumerator.class?(Enumerator)
    assert Kind::Of::Enumerator.class?(Class.new(Enumerator))

    assert_nil Kind::Of::Enumerator.or_nil('')
    assert_equal(enumerator, Kind::Of::Enumerator.or_nil(enumerator))

    assert_kind_undefined Kind::Of::Enumerator.or_undefined([])
    assert_equal(enumerator, Kind::Of::Enumerator.or_undefined(enumerator))

    # --

    assert_same(Kind::Of::Enumerator, Kind.of.Enumerator)

    Kind::Of::Enumerator.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([enumerator, {}], Kind.of.Enumerator[enumerator])
    end
  end

  # --- Set

  def test_if_a_value_is_a_kind_of_set
    set = Set.new

    assert_raises_kind_error(given: 'nil', expected: 'Set') { Kind.of.Set.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Set') { Kind.of.Set.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '[]', expected: 'Set') { Kind.of.Set.instance([]) }
    assert_equal(set, Kind.of.Set.instance(set))
    assert_equal(set, Kind.of.Set.instance(nil, or: set))
    assert_equal(set, Kind.of.Set.instance({}, or: set))
    assert_equal(set, Kind.of.Set.instance(Kind::Undefined, or: set))
    assert_raises_kind_error(given: 'nil', expected: 'Set') { Kind.of.Set.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Set') { Kind.of.Set.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Set.instance?({})
    assert Kind.of.Set.instance?(set)

    assert Kind.of.Set.class?(Set)
    assert Kind.of.Set.class?(Class.new(Set))

    assert_nil Kind.of.Set.or_nil('')
    assert_equal(set, Kind.of.Set.or_nil(set))

    assert_kind_undefined Kind.of.Set.or_undefined([])
    assert_equal(set, Kind.of.Set.or_undefined(set))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Set') { Kind::Of::Set.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Set') { Kind::Of::Set.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '[]', expected: 'Set') { Kind::Of::Set.instance([]) }
    assert_equal(set, Kind::Of::Set.instance(set))
    assert_equal(set, Kind::Of::Set.instance(nil, or: set))
    assert_equal(set, Kind::Of::Set.instance({}, or: set))
    assert_equal(set, Kind::Of::Set.instance(Kind::Undefined, or: set))
    assert_raises_kind_error(given: 'nil', expected: 'Set') { Kind::Of::Set.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Set') { Kind::Of::Set.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Set.instance?({})
    assert Kind::Of::Set.instance?(set)

    assert Kind::Of::Set.class?(Set)
    assert Kind::Of::Set.class?(Class.new(Set))

    assert_nil Kind::Of::Set.or_nil('')
    assert_equal(set, Kind::Of::Set.or_nil(set))

    assert_kind_undefined Kind::Of::Set.or_undefined([])
    assert_equal(set, Kind::Of::Set.or_undefined(set))

    # --

    assert_same(Kind::Of::Set, Kind.of.Set)

    Kind::Of::Set.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([set, {}], Kind.of.Set[set])
    end
  end

  # --- Method

  def test_if_a_value_is_a_kind_of_method
    method = [1,2].method(:first)

    assert_raises_kind_error(given: 'nil', expected: 'Method') { Kind.of.Method.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Method') { Kind.of.Method.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Method') { Kind.of.Method.instance(1) }
    assert_equal(method, Kind.of.Method.instance(method))
    assert_equal(method, Kind.of.Method.instance(nil, or: method))
    assert_equal(method, Kind.of.Method.instance(3, or: method))
    assert_equal(method, Kind.of.Method.instance(Kind::Undefined, or: method))
    assert_raises_kind_error(given: 'nil', expected: 'Method') { Kind.of.Method.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Method') { Kind.of.Method.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Method.instance?({})
    assert Kind.of.Method.instance?(method)

    assert Kind.of.Method.class?(Method)
    assert Kind.of.Method.class?(Class.new(Method))

    assert_nil Kind.of.Method.or_nil('')
    assert_equal(method, Kind.of.Method.or_nil(method))

    assert_kind_undefined Kind.of.Method.or_undefined([])
    assert_equal(method, Kind.of.Method.or_undefined(method))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Method') { Kind::Of::Method.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Method') { Kind::Of::Method.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Method') { Kind::Of::Method.instance(1) }
    assert_equal(method, Kind::Of::Method.instance(method))
    assert_equal(method, Kind::Of::Method.instance(nil, or: method))
    assert_equal(method, Kind::Of::Method.instance(3, or: method))
    assert_equal(method, Kind::Of::Method.instance(Kind::Undefined, or: method))
    assert_raises_kind_error(given: 'nil', expected: 'Method') { Kind::Of::Method.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Method') { Kind::Of::Method.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Method.instance?('')
    assert Kind::Of::Method.instance?(method)

    refute Kind::Of::Method.class?(String)
    assert Kind::Of::Method.class?(Method)
    assert Kind::Of::Method.class?(Class.new(Method))

    assert_nil Kind::Of::Method.or_nil('')
    assert_equal(method, Kind::Of::Method.or_nil(method))

    assert_kind_undefined Kind::Of::Method.or_undefined([])
    assert_equal(method, Kind::Of::Method.or_undefined(method))


    # --

    assert_same(Kind::Of::Method, Kind.of.Method)

    Kind::Of::Method.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([method, {}], Kind.of.Method[method])
    end
  end

  # --- Proc

  def test_if_a_value_is_a_kind_of_proc
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_raises_kind_error(given: 'nil', expected: 'Proc') { Kind.of.Proc.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Proc') { Kind.of.Proc.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Proc') { Kind.of.Proc.instance(1) }
    assert_equal(sum, Kind.of.Proc.instance(sum))
    assert_equal(sum, Kind.of.Proc.instance(nil, or: sum))
    assert_equal(sub, Kind.of.Proc.instance(3, or: sub))
    assert_equal(sub, Kind.of.Proc.instance(Kind::Undefined, or: sub))
    assert_raises_kind_error(given: 'nil', expected: 'Proc') { Kind.of.Proc.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Proc') { Kind.of.Proc.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Proc.instance?({})
    assert Kind.of.Proc.instance?(sum)
    assert Kind.of.Proc.instance?(sub)

    assert Kind.of.Proc.class?(Proc)
    assert Kind.of.Proc.class?(Class.new(Proc))

    assert_nil Kind.of.Proc.or_nil('')
    assert_equal(sum, Kind.of.Proc.or_nil(sum))
    assert_equal(sub, Kind.of.Proc.or_nil(sub))

    assert_kind_undefined Kind.of.Proc.or_undefined([])
    assert_equal(sum, Kind.of.Proc.or_undefined(sum))
    assert_equal(sub, Kind.of.Proc.or_undefined(sub))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Proc') { Kind::Of::Proc.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Proc') { Kind::Of::Proc.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Proc') { Kind::Of::Proc.instance(1) }
    assert_equal(sum, Kind::Of::Proc.instance(sum))
    assert_equal(sum, Kind::Of::Proc.instance(nil, or: sum))
    assert_equal(sub, Kind::Of::Proc.instance(3, or: sub))
    assert_equal(sub, Kind::Of::Proc.instance(Kind::Undefined, or: sub))
    assert_raises_kind_error(given: 'nil', expected: 'Proc') { Kind::Of::Proc.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Proc') { Kind::Of::Proc.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Proc.instance?('')
    assert Kind::Of::Proc.instance?(sum)
    assert Kind::Of::Proc.instance?(sub)

    refute Kind::Of::Proc.class?(String)
    assert Kind::Of::Proc.class?(Proc)
    assert Kind::Of::Proc.class?(Class.new(Proc))

    assert_nil Kind::Of::Proc.or_nil('')
    assert_equal(sum, Kind::Of::Proc.or_nil(sum))
    assert_equal(sub, Kind::Of::Proc.or_nil(sub))

    assert_kind_undefined Kind::Of::Proc.or_undefined([])
    assert_equal(sum, Kind::Of::Proc.or_undefined(sum))
    assert_equal(sub, Kind::Of::Proc.or_undefined(sub))

    # --

    assert_same(Kind::Of::Proc, Kind.of.Proc)

    Kind::Of::Proc.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([sum, {}], Kind.of.Proc[sum])
    end
  end

  # --- IO

  def test_if_a_value_is_a_kind_of_io
    io = IO.new(1)

    assert_raises_kind_error(given: 'nil', expected: 'IO') { Kind.of.IO.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'IO') { Kind.of.IO.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'IO') { Kind.of.IO.instance(1) }
    assert_equal(io, Kind.of.IO.instance(io))
    assert_equal(io, Kind.of.IO.instance(nil, or: io))
    assert_equal(io, Kind.of.IO.instance(3, or: io))
    assert_equal(io, Kind.of.IO.instance(Kind::Undefined, or: io))
    assert_raises_kind_error(given: 'nil', expected: 'IO') { Kind.of.IO.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'IO') { Kind.of.IO.instance(Kind::Undefined, or: nil) }

    refute Kind.of.IO.instance?({})
    assert Kind.of.IO.instance?(io)

    assert Kind.of.IO.class?(IO)
    assert Kind.of.IO.class?(Class.new(IO))

    assert_nil Kind.of.IO.or_nil('')
    assert_equal(io, Kind.of.IO.or_nil(io))

    assert_kind_undefined Kind.of.IO.or_undefined([])
    assert_equal(io, Kind.of.IO.or_undefined(io))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'IO') { Kind::Of::IO.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'IO') { Kind::Of::IO.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'IO') { Kind::Of::IO.instance(1) }
    assert_equal(io, Kind::Of::IO.instance(io))
    assert_equal(io, Kind::Of::IO.instance(nil, or: io))
    assert_equal(io, Kind::Of::IO.instance(3, or: io))
    assert_equal(io, Kind::Of::IO.instance(Kind::Undefined, or: io))
    assert_raises_kind_error(given: 'nil', expected: 'IO') { Kind::Of::IO.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'IO') { Kind::Of::IO.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::IO.instance?('')
    assert Kind::Of::IO.instance?(io)

    refute Kind::Of::IO.class?(String)
    assert Kind::Of::IO.class?(IO)
    assert Kind::Of::IO.class?(Class.new(IO))

    assert_nil Kind::Of::IO.or_nil('')
    assert_equal(io, Kind::Of::IO.or_nil(io))

    assert_kind_undefined Kind::Of::IO.or_undefined([])
    assert_equal(io, Kind::Of::IO.or_undefined(io))

    # --

    assert_same(Kind::Of::IO, Kind.of.IO)

    Kind::Of::IO.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([io, {}], Kind.of.IO[io])
    end
  end

  # --- File

  def test_if_a_value_is_a_kind_of_file
    file = File.new('.foo', 'w')

    # --

    assert_raises_kind_error(given: 'nil', expected: 'File') { Kind.of.File.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'File') { Kind.of.File.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'File') { Kind.of.File.instance(1) }
    assert_equal(file, Kind.of.File.instance(file))
    assert_equal(file, Kind.of.File.instance(nil, or: file))
    assert_equal(file, Kind.of.File.instance(3, or: file))
    assert_equal(file, Kind.of.File.instance(Kind::Undefined, or: file))
    assert_raises_kind_error(given: 'nil', expected: 'File') { Kind.of.File.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'File') { Kind.of.File.instance(Kind::Undefined, or: nil) }

    refute Kind.of.File.instance?({})
    assert Kind.of.File.instance?(file)

    assert Kind.of.File.class?(File)
    assert Kind.of.File.class?(Class.new(File))

    assert_nil Kind.of.File.or_nil('')
    assert_equal(file, Kind.of.File.or_nil(file))

    assert_kind_undefined Kind.of.File.or_undefined([])
    assert_equal(file, Kind.of.File.or_undefined(file))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'File') { Kind::Of::File.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'File') { Kind::Of::File.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'File') { Kind::Of::File.instance(1) }
    assert_equal(file, Kind::Of::File.instance(file))
    assert_equal(file, Kind::Of::File.instance(nil, or: file))
    assert_equal(file, Kind::Of::File.instance(3, or: file))
    assert_equal(file, Kind::Of::File.instance(Kind::Undefined, or: file))
    assert_raises_kind_error(given: 'nil', expected: 'File') { Kind::Of::File.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'File') { Kind::Of::File.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::File.instance?('')
    assert Kind::Of::File.instance?(file)

    refute Kind::Of::File.class?(String)
    assert Kind::Of::File.class?(File)
    assert Kind::Of::File.class?(Class.new(File))

    assert_nil Kind::Of::File.or_nil('')
    assert_equal(file, Kind::Of::File.or_nil(file))

    assert_kind_undefined Kind::Of::File.or_undefined([])
    assert_equal(file, Kind::Of::File.or_undefined(file))

    # --

    assert_same(Kind::Of::File, Kind.of.File)

    Kind::Of::File.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([file, {}], Kind.of.File[file])
    end
  end

  # --- Boolean

  def test_if_a_value_is_a_kind_of_boolean
    assert_raises_kind_error(given: 'nil', expected: 'Boolean') { Kind.of.Boolean.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Boolean') { Kind.of.Boolean.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Boolean') { Kind.of.Boolean.instance(1) }
    assert_equal(true, Kind.of.Boolean.instance(true))
    assert_equal(true, Kind.of.Boolean.instance(nil, or: true))
    assert_equal(false, Kind.of.Boolean.instance(3, or: false))
    assert_equal(false, Kind.of.Boolean.instance(Kind::Undefined, or: false))
    assert_raises_kind_error(given: 'nil', expected: 'Boolean') { Kind.of.Boolean.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Boolean') { Kind.of.Boolean.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Boolean.instance?({})
    assert Kind.of.Boolean.instance?(true)
    assert Kind.of.Boolean.instance?(false)

    refute Kind.of.Boolean.class?(String)
    assert Kind.of.Boolean.class?(TrueClass)
    assert Kind.of.Boolean.class?(FalseClass)
    assert Kind.of.Boolean.class?(Class.new(TrueClass))

    assert_nil Kind.of.Boolean.or_nil('')
    assert_equal(true, Kind.of.Boolean.or_nil(true))
    assert_equal(false, Kind.of.Boolean.or_nil(false))

    assert_kind_undefined Kind.of.Boolean.or_undefined('')
    assert_equal(true, Kind.of.Boolean.or_undefined(true))
    assert_equal(false, Kind.of.Boolean.or_undefined(false))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Boolean') { Kind::Of::Boolean.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Boolean') { Kind::Of::Boolean.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Boolean') { Kind::Of::Boolean.instance(1) }
    assert_equal(true, Kind::Of::Boolean.instance(true))
    assert_equal(true, Kind::Of::Boolean.instance(nil, or: true))
    assert_equal(false, Kind::Of::Boolean.instance(3, or: false))
    assert_equal(false, Kind::Of::Boolean.instance(Kind::Undefined, or: false))
    assert_raises_kind_error(given: 'nil', expected: 'Boolean') { Kind::Of::Boolean.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Boolean') { Kind::Of::Boolean.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Boolean.instance?('')
    assert Kind::Of::Boolean.instance?(true)
    assert Kind::Of::Boolean.instance?(false)

    refute Kind::Of::Boolean.class?(String)
    assert Kind::Of::Boolean.class?(TrueClass)
    assert Kind::Of::Boolean.class?(FalseClass)
    assert Kind::Of::Boolean.class?(Class.new(TrueClass))

    assert_nil Kind::Of::Boolean.or_nil('')
    assert_equal(true, Kind::Of::Boolean.or_nil(true))
    assert_equal(false, Kind::Of::Boolean.or_nil(false))

    assert_kind_undefined Kind::Of::Boolean.or_undefined('')
    assert_equal(true, Kind::Of::Boolean.or_undefined(true))
    assert_equal(false, Kind::Of::Boolean.or_undefined(false))

    # --

    assert_same(Kind::Of::Boolean, Kind.of.Boolean)

    Kind::Of::Boolean.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([true, {}], Kind.of.Boolean[true])
    end
  end

  # --- Lambda

  def test_if_a_value_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Lambda') { Kind::Of::Lambda.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Lambda') { Kind::Of::Lambda.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Lambda') { Kind::Of::Lambda.instance(1) }
    assert_equal(sub, Kind::Of::Lambda.instance(sub))
    assert_equal(sub, Kind::Of::Lambda.instance(nil, or: sub))
    assert_equal(sub, Kind::Of::Lambda.instance(sum, or: sub))
    assert_equal(sub, Kind::Of::Lambda.instance(Kind::Undefined, or: sub))
    assert_raises_kind_error(given: 'nil', expected: 'Lambda') { Kind::Of::Lambda.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Lambda') { Kind::Of::Lambda.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Lambda.instance?({})
    refute Kind.of.Lambda.instance?(sum)
    assert Kind.of.Lambda.instance?(sub)

    assert Kind.of.Lambda.class?(Proc)
    assert Kind.of.Lambda.class?(Class.new(Proc))

    assert_nil Kind.of.Lambda.or_nil('')
    assert_nil Kind.of.Lambda.or_nil(sum)
    assert_equal(sub, Kind.of.Lambda.or_nil(sub))

    assert_kind_undefined Kind.of.Lambda.or_undefined('')
    assert_kind_undefined Kind.of.Lambda.or_undefined(sum)
    assert_equal(sub, Kind.of.Lambda.or_undefined(sub))

    # ---

    refute Kind::Of::Lambda.instance?('')
    refute Kind::Of::Lambda.instance?(sum)
    assert Kind::Of::Lambda.instance?(sub)

    refute Kind::Of::Lambda.class?(String)
    assert Kind::Of::Lambda.class?(Proc)
    assert Kind::Of::Lambda.class?(Class.new(Proc))

    assert_nil Kind::Of::Lambda.or_nil('')
    assert_nil Kind::Of::Lambda.or_nil(sum)
    assert_equal(sub, Kind::Of::Lambda.or_nil(sub))

    # --

    assert_same(Kind::Of::Lambda, Kind.of.Lambda)

    Kind::Of::Lambda.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([sub, {}], Kind.of.Lambda[sub])
    end
  end

  # --- Callable

  def test_if_a_value_is_callable
    klass = Class.new { def self.call; end }
    instance = klass.new

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Callable') { Kind.of.Callable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Callable') { Kind.of.Callable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Callable') { Kind.of.Callable.instance(1) }
    assert_equal(sub, Kind.of.Callable.instance(sub))
    assert_equal(sum, Kind.of.Callable.instance(nil, or: sum))
    assert_equal(klass, Kind.of.Callable.instance(instance, or: klass))
    assert_equal(klass, Kind.of.Callable.instance(Kind::Undefined, or: klass))
    assert_raises_kind_error(given: 'nil', expected: 'Callable') { Kind.of.Callable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Callable') { Kind.of.Callable.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Callable.instance?({})
    refute Kind.of.Callable.instance?(instance)
    assert Kind.of.Callable.instance?(sum)
    assert Kind.of.Callable.instance?(sub)
    assert Kind.of.Callable.instance?(klass)

    assert Kind.of.Callable.class?(Proc)
    assert Kind.of.Callable.class?(klass)

    assert_nil Kind.of.Callable.or_nil('')
    assert_nil Kind.of.Callable.or_nil(instance)
    assert_equal(sub, Kind.of.Callable.or_nil(sub))
    assert_equal(klass, Kind.of.Callable.or_nil(klass))

    assert_kind_undefined Kind.of.Callable.or_undefined('')
    assert_kind_undefined Kind.of.Callable.or_undefined(instance)
    assert_equal(sub, Kind.of.Callable.or_undefined(sub))
    assert_equal(klass, Kind.of.Callable.or_undefined(klass))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Callable') { Kind::Of::Callable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Callable') { Kind::Of::Callable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Callable') { Kind::Of::Callable.instance(1) }
    assert_equal(sub, Kind::Of::Callable.instance(sub))
    assert_equal(sum, Kind::Of::Callable.instance(nil, or: sum))
    assert_equal(klass, Kind::Of::Callable.instance(instance, or: klass))
    assert_equal(klass, Kind::Of::Callable.instance(Kind::Undefined, or: klass))
    assert_raises_kind_error(given: 'nil', expected: 'Callable') { Kind::Of::Callable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Callable') { Kind::Of::Callable.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Callable.instance?({})
    refute Kind::Of::Callable.instance?(instance)
    assert Kind::Of::Callable.instance?(sum)
    assert Kind::Of::Callable.instance?(sub)
    assert Kind::Of::Callable.instance?(klass)

    assert Kind::Of::Callable.class?(Proc)
    assert Kind::Of::Callable.class?(klass)

    assert_nil Kind::Of::Callable.or_nil('')
    assert_nil Kind::Of::Callable.or_nil(instance)
    assert_equal(sub, Kind::Of::Callable.or_nil(sub))
    assert_equal(klass, Kind::Of::Callable.or_nil(klass))

    assert_kind_undefined Kind::Of::Callable.or_undefined('')
    assert_kind_undefined Kind::Of::Callable.or_undefined(instance)
    assert_equal(sub, Kind::Of::Callable.or_undefined(sub))
    assert_equal(klass, Kind::Of::Callable.or_undefined(klass))

    # --

    assert_same(Kind::Of::Callable, Kind.of.Callable)

    Kind::Of::Callable.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([klass, {}], Kind.of.Callable[klass])
    end
  end
  # --- Queue

  def test_if_a_value_is_a_kind_of_queue
    queue = Queue.new

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Thread::Queue') { Kind.of.Queue.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Thread::Queue') { Kind.of.Queue.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Thread::Queue') { Kind.of.Queue.instance(1) }
    assert_equal(queue, Kind.of.Queue.instance(queue))
    assert_equal(queue, Kind.of.Queue.instance(nil, or: queue))
    assert_equal(queue, Kind.of.Queue.instance([], or: queue))
    assert_equal(queue, Kind.of.Queue.instance(Kind::Undefined, or: queue))
    assert_raises_kind_error(given: 'nil', expected: 'Thread::Queue') { Kind.of.Queue.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Thread::Queue') { Kind.of.Queue.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Queue.instance?({})
    assert Kind.of.Queue.instance?(queue)

    assert Kind.of.Queue.class?(Queue)
    assert Kind.of.Queue.class?(Class.new(Queue))

    assert_nil Kind.of.Queue.or_nil('')
    assert_equal(queue, Kind.of.Queue.or_nil(queue))

    assert_kind_undefined Kind.of.Queue.or_undefined('')
    assert_equal(queue, Kind.of.Queue.or_undefined(queue))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Thread::Queue') { Kind::Of::Queue.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Thread::Queue') { Kind::Of::Queue.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Thread::Queue') { Kind::Of::Queue.instance(1) }
    assert_equal(queue, Kind::Of::Queue.instance(queue))
    assert_equal(queue, Kind::Of::Queue.instance(nil, or: queue))
    assert_equal(queue, Kind::Of::Queue.instance([], or: queue))
    assert_equal(queue, Kind::Of::Queue.instance(Kind::Undefined, or: queue))
    assert_raises_kind_error(given: 'nil', expected: 'Thread::Queue') { Kind::Of::Queue.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Thread::Queue') { Kind::Of::Queue.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Queue.instance?('')
    assert Kind::Of::Queue.instance?(queue)

    refute Kind::Of::Queue.class?(String)
    assert Kind::Of::Queue.class?(Queue)
    assert Kind::Of::Queue.class?(Class.new(Queue))

    assert_nil Kind::Of::Queue.or_nil('')
    assert_equal(queue, Kind::Of::Queue.or_nil(queue))

    assert_kind_undefined Kind::Of::Queue.or_undefined('')
    assert_equal(queue, Kind::Of::Queue.or_undefined(queue))

    # --

    assert_same(Kind::Of::Queue, Kind.of.Queue)

    Kind::Of::Queue.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([queue, {}], Kind.of.Queue[queue])
    end
  end

  # -- Class: Kind::Maybe

  def test_if_the_object_is_a_kind_of_maybe
    some = Kind::Maybe[1]
    none = Kind::Maybe[none]

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Kind::Maybe::Result') { Kind.of.Maybe.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Kind::Maybe::Result') { Kind.of.Maybe.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Kind::Maybe::Result') { Kind.of.Maybe.instance(1) }
    assert_equal(some, Kind.of.Maybe.instance(some))
    assert_equal(some, Kind.of.Maybe.instance(nil, or: some))
    assert_equal(none, Kind.of.Maybe.instance([], or: none))
    assert_equal(none, Kind.of.Maybe.instance(Kind::Undefined, or: none))
    assert_raises_kind_error(given: 'nil', expected: 'Kind::Maybe::Result') { Kind.of.Maybe.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Kind::Maybe::Result') { Kind.of.Maybe.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Maybe.instance?({})
    assert Kind.of.Maybe.instance?(some)
    assert Kind.of.Maybe.instance?(none)

    assert Kind.of.Maybe.class?(Kind::Maybe::Result)
    assert Kind.of.Maybe.class?(Kind::Maybe::Some)
    assert Kind.of.Maybe.class?(Kind::Maybe::None)

    assert_nil Kind.of.Maybe.or_nil('')
    assert_equal(some, Kind.of.Maybe.or_nil(some))
    assert_equal(none, Kind.of.Maybe.or_nil(none))

    assert_kind_undefined Kind.of.Maybe.or_undefined('')
    assert_equal(some, Kind.of.Maybe.or_undefined(some))
    assert_equal(none, Kind.of.Maybe.or_undefined(none))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Kind::Maybe::Result') { Kind::Of::Maybe.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Kind::Maybe::Result') { Kind::Of::Maybe.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Kind::Maybe::Result') { Kind::Of::Maybe.instance(1) }
    assert_equal(none, Kind::Of::Maybe.instance(none))
    assert_equal(none, Kind::Of::Maybe.instance(nil, or: none))
    assert_equal(some, Kind::Of::Maybe.instance([], or: some))
    assert_equal(some, Kind::Of::Maybe.instance(Kind::Undefined, or: some))
    assert_raises_kind_error(given: 'nil', expected: 'Kind::Maybe::Result') { Kind::Of::Maybe.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Kind::Maybe::Result') { Kind::Of::Maybe.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Maybe.instance?({})
    assert Kind::Of::Maybe.instance?(some)
    assert Kind::Of::Maybe.instance?(none)

    assert Kind::Of::Maybe.class?(Kind::Maybe::Result)
    assert Kind::Of::Maybe.class?(Kind::Maybe::Some)
    assert Kind::Of::Maybe.class?(Kind::Maybe::None)

    assert_nil Kind::Of::Maybe.or_nil('')
    assert_equal(some, Kind::Of::Maybe.or_nil(some))
    assert_equal(none, Kind::Of::Maybe.or_nil(none))

    assert_kind_undefined Kind::Of::Maybe.or_undefined('')
    assert_equal(some, Kind::Of::Maybe.or_undefined(some))
    assert_equal(none, Kind::Of::Maybe.or_undefined(none))

    # --

    assert_same(Kind::Of::Maybe, Kind.of.Maybe)

    Kind::Of::Maybe.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([some, {}], Kind.of.Maybe[some])
    end
  end

  # -- Modules

  def test_if_a_value_is_a_kind_of_module
    assert_raises_kind_error(given: 'nil', expected: 'Module') { Kind.of.Module.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Module') { Kind.of.Module.instance(Kind::Undefined) }
    assert_raises_kind_error(given: 'Symbol', expected: 'Module') { Kind.of.Module.instance(Symbol) }
    assert_equal(Enumerable, Kind.of.Module.instance(Enumerable))
    assert_equal(Enumerable, Kind.of.Module.instance(nil, or: Enumerable))
    assert_equal(Comparable, Kind.of.Module.instance(String, or: Comparable))
    assert_equal(Comparable, Kind.of.Module.instance(Kind::Undefined, or: Comparable))
    assert_raises_kind_error(given: 'nil', expected: 'Module') { Kind.of.Module.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Module') { Kind.of.Module.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Module.instance?([1])
    assert Kind.of.Module.instance?(Enumerable)

    assert Kind.of.Module.class?(Enumerable)
    refute Kind.of.Module.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind.of.Module.or_nil('')
    assert_equal(Enumerable, Kind.of.Module.or_nil(Enumerable))

    assert_kind_undefined Kind.of.Module.or_undefined('')
    assert_equal(Comparable, Kind.of.Module.or_undefined(Comparable))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Module') { Kind::Of::Module.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Module') { Kind::Of::Module.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Module') { Kind::Of::Module.instance(1) }
    assert_equal(Enumerable, Kind::Of::Module.instance(Enumerable))
    assert_equal(Enumerable, Kind::Of::Module.instance(nil, or: Enumerable))
    assert_equal(Comparable, Kind::Of::Module.instance([], or: Comparable))
    assert_equal(Comparable, Kind::Of::Module.instance(Kind::Undefined, or: Comparable))
    assert_raises_kind_error(given: 'nil', expected: 'Module') { Kind::Of::Module.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Module') { Kind::Of::Module.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Module.instance?([1])
    assert Kind::Of::Module.instance?(Enumerable)

    assert Kind::Of::Module.class?(Enumerable)
    refute Kind::Of::Module.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind::Of::Module.or_nil('')
    assert_equal(Enumerable, Kind::Of::Module.or_nil(Enumerable))

    assert_kind_undefined Kind::Of::Module.or_undefined('')
    assert_equal(Comparable, Kind::Of::Module.or_undefined(Comparable))

    # --

    assert_same(Kind::Of::Module, Kind.of.Module)

    Kind::Of::Module.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([Comparable, {}], Kind.of.Module[Comparable])
    end
  end

  # --- Enumerable

  def test_if_a_value_is_a_kind_of_enumerable
    value = [1]

    assert_raises_kind_error(given: 'nil', expected: 'Enumerable') { Kind.of.Enumerable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerable') { Kind.of.Enumerable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Enumerable') { Kind.of.Enumerable.instance(1) }
    assert_equal(value, Kind.of.Enumerable.instance(value))
    assert_equal(value, Kind.of.Enumerable.instance(nil, or: value))
    assert_equal(value, Kind.of.Enumerable.instance(1, or: value))
    assert_equal(value, Kind.of.Enumerable.instance(Kind::Undefined, or: value))
    assert_raises_kind_error(given: 'nil', expected: 'Enumerable') { Kind.of.Enumerable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerable') { Kind.of.Enumerable.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Enumerable.instance?(1)
    assert Kind.of.Enumerable.instance?(value)

    assert Kind.of.Enumerable.class?(Enumerable)
    assert Kind.of.Enumerable.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind.of.Enumerable.or_nil('')
    assert_equal(value, Kind.of.Enumerable.or_nil(value))

    assert_kind_undefined Kind.of.Enumerable.or_undefined('')
    assert_equal(value, Kind.of.Enumerable.or_undefined(value))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Enumerable') { Kind::Of::Enumerable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerable') { Kind::Of::Enumerable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '1', expected: 'Enumerable') { Kind::Of::Enumerable.instance(1) }
    assert_equal(value, Kind::Of::Enumerable.instance(value))
    assert_equal(value, Kind::Of::Enumerable.instance(nil, or: value))
    assert_equal(value, Kind::Of::Enumerable.instance(1, or: value))
    assert_equal(value, Kind::Of::Enumerable.instance(Kind::Undefined, or: value))
    assert_raises_kind_error(given: 'nil', expected: 'Enumerable') { Kind::Of::Enumerable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Enumerable') { Kind::Of::Enumerable.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Enumerable.instance?('')
    assert Kind::Of::Enumerable.instance?(value)

    refute Kind::Of::Enumerable.class?(String)
    assert Kind::Of::Enumerable.class?(Enumerable)
    assert Kind::Of::Enumerable.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind::Of::Enumerable.or_nil('')
    assert_equal(value, Kind::Of::Enumerable.or_nil(value))

    assert_kind_undefined Kind::Of::Enumerable.or_undefined('')
    assert_equal(value, Kind::Of::Enumerable.or_undefined(value))

    # --

    assert_same(Kind::Of::Enumerable, Kind.of.Enumerable)

    Kind::Of::Enumerable.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([value, {}], Kind.of.Enumerable[value])
    end
  end

  # --- Comparable

  def test_if_a_value_is_a_kind_of_Comparable
    value = 1

    assert_raises_kind_error(given: 'nil', expected: 'Comparable') { Kind.of.Comparable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Comparable') { Kind.of.Comparable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '[]', expected: 'Comparable') { Kind.of.Comparable.instance([]) }
    assert_equal(value, Kind.of.Comparable.instance(value))
    assert_equal(value, Kind.of.Comparable.instance(nil, or: value))
    assert_equal(value, Kind.of.Comparable.instance(1, or: value))
    assert_equal(value, Kind.of.Comparable.instance(Kind::Undefined, or: value))
    assert_raises_kind_error(given: 'nil', expected: 'Comparable') { Kind.of.Comparable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Comparable') { Kind.of.Comparable.instance(Kind::Undefined, or: nil) }

    refute Kind.of.Comparable.instance?([])
    assert Kind.of.Comparable.instance?(value)

    assert Kind.of.Comparable.class?(Comparable)
    assert Kind.of.Comparable.class?(Class.new.tap { |klass| klass.send(:include, Comparable) })

    assert_nil Kind.of.Comparable.or_nil([])
    assert_equal(value, Kind.of.Comparable.or_nil(value))

    assert_kind_undefined Kind.of.Comparable.or_undefined([])
    assert_equal(value, Kind.of.Comparable.or_undefined(value))

    # ---

    assert_raises_kind_error(given: 'nil', expected: 'Comparable') { Kind::Of::Comparable.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Comparable') { Kind::Of::Comparable.instance(Kind::Undefined) }
    assert_raises_kind_error(given: '[]', expected: 'Comparable') { Kind::Of::Comparable.instance([]) }
    assert_equal(value, Kind::Of::Comparable.instance(value))
    assert_equal(value, Kind::Of::Comparable.instance(nil, or: value))
    assert_equal(value, Kind::Of::Comparable.instance(1, or: value))
    assert_equal(value, Kind::Of::Comparable.instance(Kind::Undefined, or: value))
    assert_raises_kind_error(given: 'nil', expected: 'Comparable') { Kind::Of::Comparable.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Comparable') { Kind::Of::Comparable.instance(Kind::Undefined, or: nil) }

    refute Kind::Of::Comparable.instance?([])
    assert Kind::Of::Comparable.instance?(value)

    refute Kind::Of::Comparable.class?(Array)
    assert Kind::Of::Comparable.class?(Comparable)
    assert Kind::Of::Comparable.class?(Class.new.tap { |klass| klass.send(:include, Comparable) })

    assert_nil Kind::Of::Comparable.or_nil([])
    assert_equal(value, Kind::Of::Comparable.or_nil(value))

    assert_kind_undefined Kind::Of::Comparable.or_undefined([])
    assert_equal(value, Kind::Of::Comparable.or_undefined(value))

    # --

    assert_same(Kind::Of::Comparable, Kind.of.Comparable)

    Kind::Of::Comparable.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([value, {}], Kind.of.Comparable[value])
    end
  end
end
