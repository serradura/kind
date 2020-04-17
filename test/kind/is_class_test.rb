require 'test_helper'

class Kind::IsClassTest < Minitest::Test
  def test_if_a_value_is_a_class_or_subclass
    assert Kind.is.Class(Class)

    assert Kind.is.Class(Object)
  end

  def test_if_a_value_is_a_string_class_or_subclass
    refute Kind.is.String(Object)

    assert Kind.is.String(String)
    assert Kind.is.String(Class.new(String))
  end

  def test_if_a_value_is_a_symbol_class_or_subclass
    refute Kind.is.Symbol(Object)

    assert Kind.is.Symbol(Symbol)
    assert Kind.is.Symbol(Class.new(Symbol))
  end

  def test_if_a_value_is_a_numeric_class_or_subclass
    refute Kind.is.Numeric(Object)

    assert Kind.is.Numeric(Integer)
    assert Kind.is.Numeric(Float)
    assert Kind.is.Numeric(Class.new(Numeric))
  end

  def test_if_a_value_is_a_integer_class_or_subclass
    refute Kind.is.Integer(Object)

    assert Kind.is.Integer(Integer)
    assert Kind.is.Integer(Class.new(Integer))
  end

  def test_if_a_value_is_a_float_class_or_subclass
    refute Kind.is.Float(Object)

    assert Kind.is.Float(Float)
    assert Kind.is.Float(Class.new(Float))
  end

  def test_if_a_value_is_a_regexp_class_or_subclass
    refute Kind.is.Regexp(Object)

    assert Kind.is.Regexp(Regexp)
    assert Kind.is.Regexp(Class.new(Regexp))
  end

  def test_if_a_value_is_a_time_class_or_subclass
    refute Kind.is.Time(Object)

    assert Kind.is.Time(Time)
    assert Kind.is.Time(Class.new(Time))
  end

  def test_if_a_value_is_an_array_class_or_subclass
    refute Kind.is.Array(Object)

    assert Kind.is.Array(Array)
    assert Kind.is.Array(Class.new(Array))
  end

  def test_if_a_value_is_a_range_class_or_subclass
    refute Kind.is.Range(Object)

    assert Kind.is.Range(Range)
    assert Kind.is.Range(Class.new(Range))
  end

  def test_if_a_value_is_a_hash_class_or_subclass
    refute Kind.is.Hash(Object)

    assert Kind.is.Hash(Hash)
    assert Kind.is.Hash(Class.new(Hash))
  end

  def test_if_a_value_is_a_struct_class_or_subclass
    refute Kind.is.Struct(Object)

    assert Kind.is.Struct(Struct)
    assert Kind.is.Struct(Class.new(Struct))
  end

  def test_if_a_value_is_a_enumerator_class_or_subclass
    refute Kind.is.Enumerator(Object)

    assert Kind.is.Enumerator(Enumerator)
    assert Kind.is.Enumerator(Class.new(Enumerator))
  end

  def test_if_a_value_is_a_set_class_or_subclass
    refute Kind.is.Set(Object)

    assert Kind.is.Set(Set)
    assert Kind.is.Set(Class.new(Set))
  end

  def test_if_a_value_is_a_method_class_or_subclass
    refute Kind.is.Method(Object)

    assert Kind.is.Method(Method)
    assert Kind.is.Method(Class.new(Method))
  end

  def test_if_a_value_is_a_proc_class_or_subclass
    refute Kind.is.Proc(Object)

    assert Kind.is.Proc(Proc)
    assert Kind.is.Proc(Class.new(Proc))
  end

  def test_if_a_value_is_an_io_class_or_subclass
    refute Kind.is.IO(Object)

    assert Kind.is.IO(IO)
    assert Kind.is.IO(Class.new(IO))
  end

  def test_if_a_value_is_a_file_class_or_subclass
    refute Kind.is.File(Object)

    assert Kind.is.File(File)
    assert Kind.is.File(Class.new(File))
  end

  def test_if_a_value_is_a_queue_class_or_subclass
    refute Kind.is.Queue(Object)

    assert Kind.is.Queue(Queue)
    assert Kind.is.Queue(Class.new(Queue))
  end

  def test_if_a_value_is_a_maybe_class_or_subclass
    refute Kind.is.Maybe(Object)

    assert Kind.is.Maybe(Kind::Maybe::Result)
    assert Kind.is.Maybe(Kind::Maybe::Some)
    assert Kind.is.Maybe(Kind::Maybe::None)

    # ---

    refute Kind.is.Optional(Object)

    assert Kind.is.Optional(Kind::Optional::Result)
    assert Kind.is.Optional(Kind::Optional::Some)
    assert Kind.is.Optional(Kind::Optional::None)
  end

  def test_if_a_value_is_a_boolean_class_or_subclass
    refute Kind.is.Boolean(Object)

    assert Kind.is.Boolean(TrueClass)
    assert Kind.is.Boolean(FalseClass)

    assert Kind.is.Boolean(Class.new(TrueClass))
    assert Kind.is.Boolean(Class.new(FalseClass))
  end

  def test_if_a_value_is_callable
    refute Kind.is.Callable(String)

    assert Kind.is.Callable(Proc)
    assert Kind.is.Callable(Method)

    klass = Class.new { def self.call; end }

    assert Kind.is.Callable(klass)
  end
end
