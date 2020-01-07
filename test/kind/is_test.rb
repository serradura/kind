require 'test_helper'

class Kind::IsTest < Minitest::Test
  # -- Classes

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

  def test_if_a_value_is_a_boolean_class_or_subclass
    refute Kind.is.Boolean(Object)

    assert Kind.is.Boolean(TrueClass)
    assert Kind.is.Boolean(FalseClass)

    assert Kind.is.Boolean(Class.new(TrueClass))
    assert Kind.is.Boolean(Class.new(FalseClass))
  end

  # -- Modules

  def test_if_a_value_is_a_module
    assert Kind.is.Module(Module)
    assert Kind.is.Module(Enumerable)

    refute Kind.is.Module(Object)
  end

  def test_if_a_value_is_an_enumerable_module
    assert Kind.is.Enumerable(Enumerable)
    assert Kind.is.Module(Module.new { extend Enumerable })

    refute Kind.is.Enumerable(Module)
    refute Kind.is.Enumerable(Comparable)
  end

  def test_if_a_value_is_a_comparable_module
    assert Kind.is.Comparable(Comparable)
    assert Kind.is.Module(Module.new { extend Comparable })

    refute Kind.is.Comparable(Module)
    refute Kind.is.Comparable(Enumerable)
  end
end
