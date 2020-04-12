require 'test_helper'

class Kind::OfCheckersTest < Minitest::Test
  # -- Classes

  def test_if_a_value_is_a_kind_of_class
    refute Kind.of.Class.instance?([1])
    refute Kind.of.Class.instance?(Enumerable)
    assert Kind.of.Class.instance?(String)
    assert Kind.of.Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    refute Kind.of.Class.class?(Enumerable)
    assert Kind.of.Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind.of.Class.or_nil('')
    assert_equal(String, Kind.of.Class.or_nil(String))

    # ---

    refute Kind::Of::Class.instance?([1])
    refute Kind::Of::Class.instance?(Enumerable)
    assert Kind::Of::Class.instance?(String)
    assert Kind::Of::Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    refute Kind::Of::Class.class?(Enumerable)
    assert Kind::Of::Class.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind::Of::Class.or_nil('')
    assert_equal(String, Kind::Of::Class.or_nil(String))
  end

  # --- String

  def test_if_a_value_is_a_kind_of_string
    refute Kind.of.String.instance?({})
    assert Kind.of.String.instance?('')

    assert_equal(false, Kind.of.String.class?(Hash))
    assert_equal(true, Kind.of.String.class?(String))
    assert_equal(true, Kind.of.String.class?(Class.new(String)))

    assert_nil Kind.of.String.or_nil({})
    assert_equal('a', Kind.of.String.or_nil('a'))

    # ---

    refute Kind::Of::String.instance?({})
    assert Kind::Of::String.instance?('')

    refute Kind::Of::String.class?(Hash)
    assert Kind::Of::String.class?(String)
    assert Kind::Of::String.class?(Class.new(String))

    assert_nil Kind::Of::String.or_nil({})
    assert_equal('a', Kind::Of::String.or_nil('a'))
  end

  # --- Symbol

  def test_if_a_value_is_a_kind_of_symbol
    refute Kind.of.Symbol.instance?({})
    assert Kind.of.Symbol.instance?(:a)

    refute Kind.of.Symbol.class?(Hash)
    assert Kind.of.Symbol.class?(Symbol)
    assert Kind.of.Symbol.class?(Class.new(Symbol))

    assert_nil Kind.of.Symbol.or_nil({})
    assert_equal(:a, Kind.of.Symbol.or_nil(:a))

    # ---

    refute Kind::Of::Symbol.instance?({})
    assert Kind::Of::Symbol.instance?(:a)

    refute Kind::Of::Symbol.class?(Hash)
    assert Kind::Of::Symbol.class?(Symbol)
    assert Kind::Of::Symbol.class?(Class.new(Symbol))

    assert_nil Kind::Of::Symbol.or_nil({})
    assert_equal(:a, Kind::Of::Symbol.or_nil(:a))
  end

  # --- Numeric

  def test_if_a_value_is_a_kind_of_numeric
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

    # ---

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
  end

  # --- Integer

  def test_if_a_value_is_a_kind_of_integer
    refute Kind.of.Integer.instance?({})
    assert Kind.of.Integer.instance?(1)

    refute Kind.of.Integer.class?(Hash)
    assert Kind.of.Integer.class?(Integer)
    assert Kind.of.Integer.class?(Class.new(Integer))

    assert_nil Kind.of.Integer.or_nil({})
    assert_nil Kind.of.Integer.or_nil(1.0)
    assert_equal(1, Kind.of.Integer.or_nil(1))

    # ---

    refute Kind::Of::Integer.instance?({})
    assert Kind::Of::Integer.instance?(1)

    refute Kind::Of::Integer.class?(Hash)
    assert Kind::Of::Integer.class?(Integer)
    assert Kind::Of::Integer.class?(Class.new(Integer))

    assert_nil Kind::Of::Integer.or_nil({})
    assert_nil Kind::Of::Integer.or_nil(1.0)
    assert_equal(1, Kind::Of::Integer.or_nil(1))
  end

  # --- Float

  def test_if_a_value_is_a_kind_of_Float
    refute Kind.of.Float.instance?({})
    assert Kind.of.Float.instance?(1.0)

    refute Kind.of.Float.class?(Hash)
    assert Kind.of.Float.class?(Float)
    assert Kind.of.Float.class?(Class.new(Float))

    assert_nil Kind.of.Float.or_nil({})
    assert_nil Kind.of.Float.or_nil(1)
    assert_equal(1.0, Kind.of.Float.or_nil(1.0))

    # ---

    refute Kind::Of::Float.instance?({})
    assert Kind::Of::Float.instance?(1.0)

    refute Kind::Of::Float.class?(Hash)
    assert Kind::Of::Float.class?(Float)
    assert Kind::Of::Float.class?(Class.new(Float))

    assert_nil Kind::Of::Float.or_nil({})
    assert_nil Kind::Of::Float.or_nil(1)
    assert_equal(1.0, Kind::Of::Float.or_nil(1.0))
  end

  # --- Regexp

  def test_if_a_value_is_a_kind_of_regexp
    refute Kind.of.Regexp.instance?({})
    assert Kind.of.Regexp.instance?(/1.0/)

    refute Kind.of.Regexp.class?(Hash)
    assert Kind.of.Regexp.class?(Regexp)
    assert Kind.of.Regexp.class?(Class.new(Regexp))

    assert_nil Kind.of.Regexp.or_nil({})
    assert_equal(/1.0/, Kind.of.Regexp.or_nil(/1.0/))

    # ---

    refute Kind::Of::Regexp.instance?({})
    assert Kind::Of::Regexp.instance?(/1.0/)

    refute Kind::Of::Regexp.class?(Hash)
    assert Kind::Of::Regexp.class?(Regexp)
    assert Kind::Of::Regexp.class?(Class.new(Regexp))

    assert_nil Kind::Of::Regexp.or_nil({})
    assert_equal(/1.0/, Kind::Of::Regexp.or_nil(/1.0/))
  end

  # --- Time

  def test_if_a_value_is_a_kind_of_time
    now = Time.now

    refute Kind.of.Time.instance?({})
    assert Kind.of.Time.instance?(now)

    refute Kind.of.Time.class?(Hash)
    assert Kind.of.Time.class?(Time)
    assert Kind.of.Time.class?(Class.new(Time))

    assert_nil Kind.of.Time.or_nil({})
    assert_equal(now, Kind.of.Time.or_nil(now))

    # ---

    refute Kind::Of::Time.instance?({})
    assert Kind::Of::Time.instance?(now)

    refute Kind::Of::Time.class?(Hash)
    assert Kind::Of::Time.class?(Time)
    assert Kind::Of::Time.class?(Class.new(Time))

    assert_nil Kind::Of::Time.or_nil({})
    assert_equal(now, Kind::Of::Time.or_nil(now))
  end

  # --- Array

  def test_if_a_value_is_a_kind_of_array
    refute Kind.of.Array.instance?({})
    assert Kind.of.Array.instance?([])

    assert Kind.of.Array.class?(Array)
    assert Kind.of.Array.class?(Class.new(Array))

    assert_nil Kind.of.Array.or_nil({})
    assert_equal([1], Kind.of.Array.or_nil([1]))

    # ---

    refute Kind::Of::Array.instance?({})
    assert Kind::Of::Array.instance?([])

    refute Kind::Of::Array.class?(Hash)
    assert Kind::Of::Array.class?(Array)
    assert Kind::Of::Array.class?(Class.new(Array))

    assert_nil Kind::Of::Array.or_nil({})
    assert_equal([1], Kind::Of::Array.or_nil([1]))
  end

  # --- Range

  def test_if_a_value_is_a_kind_of_range
    range = 1..2

    refute Kind.of.Range.instance?({})
    assert Kind.of.Range.instance?(range)

    assert Kind.of.Range.class?(Range)
    assert Kind.of.Range.class?(Class.new(Range))

    assert_nil Kind.of.Range.or_nil({})
    assert_equal(range, Kind.of.Range.or_nil(range))

    # ---

    refute Kind::Of::Range.instance?({})
    assert Kind::Of::Range.instance?(range)

    refute Kind::Of::Range.class?(Hash)
    assert Kind::Of::Range.class?(Range)
    assert Kind::Of::Range.class?(Class.new(Range))

    assert_nil Kind::Of::Range.or_nil({})
    assert_equal(range, Kind::Of::Range.or_nil(range))
  end

  # --- Hash

  def test_if_a_value_is_a_kind_of_hash
    refute Kind.of.Hash.instance?('')
    assert Kind.of.Hash.instance?({})

    assert Kind.of.Hash.class?(Hash)
    assert Kind.of.Hash.class?(Class.new(Hash))

    assert_nil Kind.of.Hash.or_nil('')
    assert_equal({a: 1}, Kind.of.Hash.or_nil(a: 1))

    # ---

    refute Kind::Of::Hash.instance?('')
    assert Kind::Of::Hash.instance?({})

    refute Kind::Of::Hash.class?(String)
    assert Kind::Of::Hash.class?(Hash)
    assert Kind::Of::Hash.class?(Class.new(Hash))

    assert_nil Kind::Of::Hash.or_nil('')
    assert_equal({a: 1}, Kind::Of::Hash.or_nil(a: 1))
  end

  # --- Struct

  def test_if_a_value_is_a_kind_of_struct
    struct = Struct.new(:name)
    person = struct.new('John Doe')

    refute Kind.of.Struct.instance?({})
    assert Kind.of.Struct.instance?(person)

    assert Kind.of.Struct.class?(Struct)
    assert Kind.of.Struct.class?(Class.new(Struct))

    assert_nil Kind.of.Struct.or_nil('')
    assert_equal(person, Kind.of.Struct.or_nil(person))

    # ---

    refute Kind::Of::Struct.instance?('')
    assert Kind::Of::Struct.instance?(person)

    refute Kind::Of::Struct.class?(String)
    assert Kind::Of::Struct.class?(Struct)
    assert Kind::Of::Struct.class?(Class.new(Struct))

    assert_nil Kind::Of::Struct.or_nil('')
    assert_equal(person, Kind::Of::Struct.or_nil(person))
  end

  # --- Enumerator

  def test_if_a_value_is_a_kind_of_enumerator
    enumerator = [].each

    refute Kind.of.Enumerator.instance?({})
    assert Kind.of.Enumerator.instance?(enumerator)

    assert Kind.of.Enumerator.class?(Enumerator)
    assert Kind.of.Enumerator.class?(Class.new(Enumerator))

    assert_nil Kind.of.Enumerator.or_nil('')
    assert_equal(enumerator, Kind.of.Enumerator.or_nil(enumerator))

    # ---

    refute Kind::Of::Enumerator.instance?('')
    assert Kind::Of::Enumerator.instance?(enumerator)

    refute Kind::Of::Enumerator.class?(String)
    assert Kind::Of::Enumerator.class?(Enumerator)
    assert Kind::Of::Enumerator.class?(Class.new(Enumerator))

    assert_nil Kind::Of::Enumerator.or_nil('')
    assert_equal(enumerator, Kind::Of::Enumerator.or_nil(enumerator))
  end

  # --- Method

  def test_if_a_value_is_a_kind_of_method
    method = [1,2].method(:first)

    refute Kind.of.Method.instance?({})
    assert Kind.of.Method.instance?(method)

    assert Kind.of.Method.class?(Method)
    assert Kind.of.Method.class?(Class.new(Method))

    assert_nil Kind.of.Method.or_nil('')
    assert_equal(method, Kind.of.Method.or_nil(method))

    # ---

    refute Kind::Of::Method.instance?('')
    assert Kind::Of::Method.instance?(method)

    refute Kind::Of::Method.class?(String)
    assert Kind::Of::Method.class?(Method)
    assert Kind::Of::Method.class?(Class.new(Method))

    assert_nil Kind::Of::Method.or_nil('')
    assert_equal(method, Kind::Of::Method.or_nil(method))
  end

  # --- Proc

  def test_if_a_value_is_a_kind_of_proc
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    refute Kind.of.Proc.instance?({})
    assert Kind.of.Proc.instance?(sum)
    assert Kind.of.Proc.instance?(sub)

    assert Kind.of.Proc.class?(Proc)
    assert Kind.of.Proc.class?(Class.new(Proc))

    assert_nil Kind.of.Proc.or_nil('')
    assert_equal(sum, Kind.of.Proc.or_nil(sum))
    assert_equal(sub, Kind.of.Proc.or_nil(sub))

    # ---

    refute Kind::Of::Proc.instance?('')
    assert Kind::Of::Proc.instance?(sum)
    assert Kind::Of::Proc.instance?(sub)

    refute Kind::Of::Proc.class?(String)
    assert Kind::Of::Proc.class?(Proc)
    assert Kind::Of::Proc.class?(Class.new(Proc))

    assert_nil Kind::Of::Proc.or_nil('')
    assert_equal(sum, Kind::Of::Proc.or_nil(sum))
    assert_equal(sub, Kind::Of::Proc.or_nil(sub))
  end

  # --- IO

  def test_if_a_value_is_a_kind_of_io
    io = IO.new(1)

    refute Kind.of.IO.instance?({})
    assert Kind.of.IO.instance?(io)

    assert Kind.of.IO.class?(IO)
    assert Kind.of.IO.class?(Class.new(IO))

    assert_nil Kind.of.IO.or_nil('')
    assert_equal(io, Kind.of.IO.or_nil(io))

    # ---

    refute Kind::Of::IO.instance?('')
    assert Kind::Of::IO.instance?(io)

    refute Kind::Of::IO.class?(String)
    assert Kind::Of::IO.class?(IO)
    assert Kind::Of::IO.class?(Class.new(IO))

    assert_nil Kind::Of::IO.or_nil('')
    assert_equal(io, Kind::Of::IO.or_nil(io))
  end

  # --- File

  def test_if_a_value_is_a_kind_of_file
    file = File.new('.foo', 'w')

    # --

    refute Kind.of.File.instance?({})
    assert Kind.of.File.instance?(file)

    assert Kind.of.File.class?(File)
    assert Kind.of.File.class?(Class.new(File))

    assert_nil Kind.of.File.or_nil('')
    assert_equal(file, Kind.of.File.or_nil(file))

    # ---

    refute Kind::Of::File.instance?('')
    assert Kind::Of::File.instance?(file)

    refute Kind::Of::File.class?(String)
    assert Kind::Of::File.class?(File)
    assert Kind::Of::File.class?(Class.new(File))

    assert_nil Kind::Of::File.or_nil('')
    assert_equal(file, Kind::Of::File.or_nil(file))
  end

  # --- Boolean

  def test_if_a_value_is_a_kind_of_boolean
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

    # ---

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
  end

  # --- Lambda

  def test_if_a_value_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # ---

    refute Kind.of.Lambda.instance?({})
    refute Kind.of.Lambda.instance?(sum)
    assert Kind.of.Lambda.instance?(sub)

    assert Kind.of.Lambda.class?(Proc)
    assert Kind.of.Lambda.class?(Class.new(Proc))

    assert_nil Kind.of.Lambda.or_nil('')
    assert_nil Kind.of.Lambda.or_nil(sum)
    assert_equal(sub, Kind.of.Lambda.or_nil(sub))

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
  end

  # --- Callable

  def test_if_a_value_is_callable
    klass = Class.new { def self.call; end }
    instance = klass.new

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # ---

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

    # ---

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
  end
  # --- Queue

  def test_if_a_value_is_a_kind_of_queue
    queue = Queue.new

    # ---

    refute Kind.of.Queue.instance?({})
    assert Kind.of.Queue.instance?(queue)

    assert Kind.of.Queue.class?(Queue)
    assert Kind.of.Queue.class?(Class.new(Queue))

    assert_nil Kind.of.Queue.or_nil('')
    assert_equal(queue, Kind.of.Queue.or_nil(queue))

    # ---

    refute Kind::Of::Queue.instance?('')
    assert Kind::Of::Queue.instance?(queue)

    refute Kind::Of::Queue.class?(String)
    assert Kind::Of::Queue.class?(Queue)
    assert Kind::Of::Queue.class?(Class.new(Queue))

    assert_nil Kind::Of::Queue.or_nil('')
    assert_equal(queue, Kind::Of::Queue.or_nil(queue))
  end

  # -- Modules

  def test_if_a_value_is_a_kind_of_module
    refute Kind.of.Module.instance?([1])
    assert Kind.of.Module.instance?(Enumerable)

    assert Kind.of.Module.class?(Enumerable)
    refute Kind.of.Module.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind.of.Module.or_nil('')
    assert_equal(Enumerable, Kind.of.Module.or_nil(Enumerable))

    # ---

    refute Kind::Of::Module.instance?([1])
    assert Kind::Of::Module.instance?(Enumerable)

    assert Kind::Of::Module.class?(Enumerable)
    refute Kind::Of::Module.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind::Of::Module.or_nil('')
    assert_equal(Enumerable, Kind::Of::Module.or_nil(Enumerable))
  end

  # --- Enumerable

  def test_if_a_value_is_a_kind_of_enumerable
    value = [1]

    refute Kind.of.Enumerable.instance?(1)
    assert Kind.of.Enumerable.instance?(value)

    assert Kind.of.Enumerable.class?(Enumerable)
    assert Kind.of.Enumerable.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind.of.Enumerable.or_nil('')
    assert_equal(value, Kind.of.Enumerable.or_nil(value))

    # ---

    refute Kind::Of::Enumerable.instance?('')
    assert Kind::Of::Enumerable.instance?(value)

    refute Kind::Of::Enumerable.class?(String)
    assert Kind::Of::Enumerable.class?(Enumerable)
    assert Kind::Of::Enumerable.class?(Class.new.tap { |klass| klass.send(:include, Enumerable) })

    assert_nil Kind::Of::Enumerable.or_nil('')
    assert_equal(value, Kind::Of::Enumerable.or_nil(value))
  end

  # --- Comparable

  def test_if_a_value_is_a_kind_of_Comparable
    value = 1

    refute Kind.of.Comparable.instance?([])
    assert Kind.of.Comparable.instance?(value)

    assert Kind.of.Comparable.class?(Comparable)
    assert Kind.of.Comparable.class?(Class.new.tap { |klass| klass.send(:include, Comparable) })

    assert_nil Kind.of.Comparable.or_nil([])
    assert_equal(value, Kind.of.Comparable.or_nil(value))

    # ---

    refute Kind::Of::Comparable.instance?([])
    assert Kind::Of::Comparable.instance?(value)

    refute Kind::Of::Comparable.class?(Array)
    assert Kind::Of::Comparable.class?(Comparable)
    assert Kind::Of::Comparable.class?(Class.new.tap { |klass| klass.send(:include, Comparable) })

    assert_nil Kind::Of::Comparable.or_nil([])
    assert_equal(value, Kind::Of::Comparable.or_nil(value))
  end
end
