require 'test_helper'

class Kind::IsClassTest < Minitest::Test
  def test_if_a_value_is_a_class_or_subclass
    assert_kind_is(:Class, Class, String)

    refute_kind_is(:Class, Enumerable, Object.new)
  end

  def test_if_a_value_is_a_string_class_or_subclass
    assert_kind_is(:String, String, Class.new(String))

    refute_kind_is(:String, Object)
  end

  def test_if_a_value_is_a_symbol_class_or_subclass
    assert_kind_is(:Symbol, Symbol, Class.new(Symbol))

    refute_kind_is(:Symbol, Object)
  end

  def test_if_a_value_is_a_numeric_class_or_subclass
    assert_kind_is(:Numeric, Integer, Float, Numeric)

    refute_kind_is(:Numeric, Object)
  end

  def test_if_a_value_is_a_integer_class_or_subclass
    assert_kind_is(:Integer, Integer, Class.new(Integer))

    refute_kind_is(:Integer, Object, Float, Numeric)
  end

  def test_if_a_value_is_a_float_class_or_subclass
    assert_kind_is(:Float, Float, Class.new(Float))

    refute_kind_is(:Float, Object, Integer, Numeric)
  end

  def test_if_a_value_is_a_regexp_class_or_subclass
    assert_kind_is(:Regexp, Regexp, Class.new(Regexp))

    refute_kind_is(:Regexp, Object)
  end

  def test_if_a_value_is_a_time_class_or_subclass
    assert_kind_is(:Time, Time, Class.new(Time))

    refute_kind_is(:Time, Object)
  end

  def test_if_a_value_is_an_array_class_or_subclass
    assert_kind_is(:Array, Array, Class.new(Array))

    refute_kind_is(:Array, Object)
  end

  def test_if_a_value_is_a_range_class_or_subclass
    assert_kind_is(:Range, Range, Class.new(Range))

    refute_kind_is(:Range, Object)
  end

  def test_if_a_value_is_a_hash_class_or_subclass
    assert_kind_is(:Hash, Hash, Class.new(Hash))

    refute_kind_is(:Hash, Object)
  end

  def test_if_a_value_is_a_struct_class_or_subclass
    assert_kind_is(:Struct, Struct, Class.new(Struct))

    refute_kind_is(:Struct, Object, Hash)
  end

  def test_if_a_value_is_a_enumerator_class_or_subclass
    assert_kind_is(:Enumerator, Enumerator, Class.new(Enumerator))

    refute_kind_is(:Enumerator, Object, Hash)
  end

  def test_if_a_value_is_a_set_class_or_subclass
    assert_kind_is(:Set, Set, Class.new(Set))

    refute_kind_is(:Set, Object, Hash, Array)
  end

  def test_if_a_value_is_a_open_struct_class_or_subclass
    assert_kind_is(:OpenStruct, OpenStruct, Class.new(OpenStruct))

    refute_kind_is(:OpenStruct, Object, Hash, Array)
  end

  def test_if_a_value_is_a_method_class_or_subclass
    assert_kind_is(:Method, Method, Class.new(Method))

    refute_kind_is(:Method, Object, Proc)
  end

  def test_if_a_value_is_a_proc_class_or_subclass
    assert_kind_is(:Proc, Proc, Class.new(Proc))

    refute_kind_is(:Proc, Object, Method)
  end

  def test_if_a_value_is_an_io_class_or_subclass
    assert_kind_is(:IO, IO, Class.new(IO), File)

    refute_kind_is(:IO, Object, String)
  end

  def test_if_a_value_is_a_file_class_or_subclass
    assert_kind_is(:File, File, Class.new(File))

    refute_kind_is(:File, Object, String)
  end

  def test_if_a_value_is_a_queue_class_or_subclass
    assert_kind_is(:Queue, Queue, Class.new(Queue))

    refute_kind_is(:Queue, Object, Array)
  end

  def test_if_a_value_is_a_maybe_class_or_subclass
    assert_kind_is(:Maybe, Kind::Maybe::Result, Kind::Maybe::Some, Kind::Maybe::None)

    refute_kind_is(:Maybe, Object)

    # ---

    assert_kind_is(:Optional, Kind::Optional::Result, Kind::Optional::Some, Kind::Optional::None)

    refute_kind_is(:Optional, Object)
  end

  def test_if_a_value_is_a_boolean_class_or_subclass
    assert_kind_is(:Boolean, TrueClass, FalseClass, Class.new(TrueClass), Class.new(FalseClass))

    refute_kind_is(:Boolean, Object)
  end

  def test_if_a_value_is_callable
    klass = Class.new { def self.call; end }

    assert_kind_is(:Callable, klass)

    refute_kind_is(:Callable, Object, String, Proc, Method)
  end
end
