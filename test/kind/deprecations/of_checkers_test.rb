require 'test_helper'

class Kind::OfCheckersTest < Minitest::Test
  # -- Classes

  def test_if_a_value_is_a_kind_of_class
    assert_kind_checker(:Class,
      instance: {
        valid: [String, Symbol],
        invalid: [:a, Enumerable]
      },
      class: {
        valid: [String, Class.new.tap { |klass| klass.send(:include, Enumerable) }],
        invalid: [Enumerable]
      }
    )
  end

  # --- String

  def test_if_a_value_is_a_kind_of_string
    assert_kind_checker(:String,
      instance: {
        valid: ['a', 'b'],
        invalid: [:a, {}]
      },
      class: {
        valid: [String, Class.new(String)],
        invalid: [Hash]
      }
    )
  end

  # --- Symbol

  def test_if_a_value_is_a_kind_of_symbol
    assert_kind_checker(:Symbol,
      instance: {
        valid: [:a, :b],
        invalid: ['1', {}]
      },
      class: {
        valid: [Symbol, Class.new(Symbol)],
        invalid: [Hash]
      }
    )
  end

  # --- Numeric

  def test_if_a_value_is_a_kind_of_numeric
    assert_kind_checker(:Numeric,
      instance: {
        valid: [1, 2.0],
        invalid: ['1', {}]
      },
      class: {
        valid: [Numeric, Float, Integer],
        invalid: [Hash]
      }
    )
  end

  # --- Integer

  def test_if_a_value_is_a_kind_of_integer
    assert_kind_checker(:Integer,
      instance: {
        valid: [1, 2],
        invalid: ['1', 1.0]
      },
      class: {
        valid: [Integer, Class.new(Integer)],
        invalid: [Numeric, Float]
      }
    )
  end

  # --- Float

  def test_if_a_value_is_a_kind_of_Float
    assert_kind_checker(:Float,
      instance: {
        valid: [1.0, 2.0],
        invalid: ['1', 1]
      },
      class: {
        valid: [Float, Class.new(Float)],
        invalid: [Numeric, Integer]
      }
    )
  end

  # --- Regexp

  def test_if_a_value_is_a_kind_of_regexp
    assert_kind_checker(:Regexp,
      instance: {
        valid: [/1.0/, /^[a-z]/],
        invalid: ['1', 1]
      },
      class: {
        valid: [Regexp, Class.new(Regexp)],
        invalid: [String]
      }
    )
  end

  # --- Time

  def test_if_a_value_is_a_kind_of_time
    assert_kind_checker(:Time,
      instance: {
        valid: [Time.now],
        invalid: ['1', 1]
      },
      class: {
        valid: [Time, Class.new(Time)],
        invalid: [String]
      }
    )
  end

  # --- Array

  def test_if_a_value_is_a_kind_of_array
    assert_kind_checker(:Array,
      instance: {
        valid: [[]],
        invalid: ['1', 1]
      },
      class: {
        valid: [Array, Class.new(Array)],
        invalid: [String, Hash]
      }
    )
  end

  # --- Range

  def test_if_a_value_is_a_kind_of_range
    assert_kind_checker(:Range,
      instance: {
        valid: [1..2],
        invalid: ['1', 1]
      },
      class: {
        valid: [Range, Class.new(Range)],
        invalid: [String, Hash]
      }
    )
  end

  # --- Hash

  def test_if_a_value_is_a_kind_of_hash
    assert_kind_checker(:Hash,
      instance: {
        valid: [{}],
        invalid: ['1', 1]
      },
      class: {
        valid: [Hash, Class.new(Hash)],
        invalid: [String, Array]
      }
    )
  end

  # --- Struct

  def test_if_a_value_is_a_kind_of_struct
    struct = Struct.new(:name)
    person = struct.new('John Doe')

    assert_kind_checker(:Struct,
      instance: {
        valid: [person],
        invalid: ['1', {}]
      },
      class: {
        valid: [Struct, struct],
        invalid: [Hash]
      }
    )
  end

  # --- Enumerator

  def test_if_a_value_is_a_kind_of_enumerator
    enumerator = [].each

    assert_kind_checker(:Enumerator,
      instance: {
        valid: [enumerator],
        invalid: ['1', {}]
      },
      class: {
        valid: [Enumerator],
        invalid: [Hash, Array]
      }
    )
  end

  # --- Set

  def test_if_a_value_is_a_kind_of_set
    set = Set.new

    assert_kind_checker(:Set,
      instance: {
        valid: [set],
        invalid: [[], {}]
      },
      class: {
        valid: [Set],
        invalid: [Hash, Array]
      }
    )
  end

  # --- OpenStruct

  def test_if_a_value_is_a_kind_of_open_struct
    ostruct = OpenStruct.new

    assert_kind_checker(:OpenStruct,
      instance: {
        valid: [ostruct],
        invalid: [[], {}]
      },
      class: {
        valid: [OpenStruct],
        invalid: [Hash, Array]
      }
    )
  end

  # --- Method

  def test_if_a_value_is_a_kind_of_method
    method = [1,2].method(:first)

    assert_kind_checker(:Method,
      instance: {
        valid: [method],
        invalid: [proc {}, lambda {}]
      },
      class: {
        valid: [Method],
        invalid: [Proc]
      }
    )
  end

  # --- Proc

  def test_if_a_value_is_a_kind_of_proc
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_kind_checker(:Proc,
      instance: {
        valid: [sum, sub],
        invalid: [1, '1']
      },
      class: {
        valid: [Proc],
        invalid: [Method]
      }
    )
  end

  # --- IO

  def test_if_a_value_is_a_kind_of_io
    io = IO.new(1)

    assert_kind_checker(:IO,
      instance: {
        valid: [io],
        invalid: [1, '1']
      },
      class: {
        valid: [IO, File],
        invalid: [String]
      }
    )
  end

  # --- File

  def test_if_a_value_is_a_kind_of_file
    file = File.new('.foo', 'w')

    assert_kind_checker(:File,
      instance: {
        valid: [file],
        invalid: [1, '1']
      },
      class: {
        valid: [File],
        invalid: [IO, String]
      }
    )
  end

  # --- Boolean

  def test_if_a_value_is_a_kind_of_boolean
    assert_kind_checker(:Boolean,
      instance: {
        valid: [true, false],
        invalid: [1, '0']
      },
      class: {
        valid: [TrueClass, FalseClass],
        invalid: [String]
      }
    )
  end

  # --- Lambda

  def test_if_a_value_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_kind_checker(:Lambda,
      instance: {
        valid: [sub],
        invalid: [sum]
      },
      class: {
        valid: [Proc],
        invalid: [Method]
      }
    )
  end

  # --- Callable

  def test_if_a_value_is_callable
    klass = Class.new { def self.call; end }
    instance = klass.new

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_kind_checker(:Callable,
      instance: {
        valid: [sum, sub, klass],
        invalid: [instance]
      },
      class: {
        valid: [klass],
        invalid: [String, Method, Proc]
      }
    )
  end
  # --- Queue

  def test_if_a_value_is_a_kind_of_queue
    queue = Queue.new

    assert_kind_checker(:Queue,
      kind_name: 'Thread::Queue',
      instance: {
        valid: [queue],
        invalid: [[], {}]
      },
      class: {
        valid: [Queue, Class.new(Queue)],
        invalid: [Hash, Array]
      }
    )
  end

  # -- Class: Kind::Maybe

  def test_if_the_object_is_a_kind_of_maybe
    some = Kind::Maybe[1]
    none = Kind::Maybe[none]

    assert_kind_checker(:Maybe,
      kind_name: 'Kind::Maybe::Result',
      instance: {
        valid: [some, none],
        invalid: [[], {}]
      },
      class: {
        valid: [Kind::Maybe::Result, Kind::Maybe::Some, Kind::Maybe::None],
        invalid: [Hash, Array]
      }
    )
  end

  # -- Modules

  def test_if_a_value_is_a_kind_of_module
    assert_kind_checker(:Module,
      instance: {
        valid: [Enumerable, Comparable],
        invalid: [String, Array]
      },
      class: {
        valid: [Enumerable, Comparable],
        invalid: [Class.new.tap { |klass| klass.send(:include, Enumerable) }]
      }
    )
  end

  # --- Enumerable

  def test_if_a_value_is_a_kind_of_enumerable
    hash = {a: 1}
    array = [1]
    range = 1..2

    assert_kind_checker(:Enumerable,
      instance: {
        valid: [hash, array, range],
        invalid: [:a, 1]
      },
      class: {
        valid: [Enumerable, Class.new.tap { |klass| klass.send(:include, Enumerable) }],
        invalid: [Symbol]
      }
    )
  end

  # --- Comparable

  def test_if_a_value_is_a_kind_of_Comparable
    assert_kind_checker(:Comparable,
      instance: {
        valid: [1, 'a'],
        invalid: [[], {}]
      },
      class: {
        valid: [String, Comparable, Class.new.tap { |klass| klass.send(:include, Comparable) }],
        invalid: [Array, Hash]
      }
    )
  end
end
