require 'test_helper'

class Kind::ModulesTest < Minitest::Test
  def test_the_core_modules
    # == Kind::Array ==

    assert Kind.of_module?(Kind::Array)
    assert Kind.is?(Kind::Object, Kind::Array)
    assert Kind::Array.kind == ::Array
    assert Kind::Array.name == 'Array'
    assert Kind::Array?([])
    assert Kind::Array?([], [])
    refute Kind::Array?([], 1)

    assert_equal([1], Kind::Array.value_or_empty([1]))
    assert_kind_of(::Array, Kind::Array.value_or_empty(1))
    assert_predicate(Kind::Array.value_or_empty(1), :empty?)
    assert_predicate(Kind::Array.value_or_empty(1), :frozen?)

    assert_equal(Kind::Array.value_or_empty(nil), Kind::Array.empty_or(nil))

    union_type = Kind::Array | Kind::Hash
    assert union_type === []
    assert union_type === {}
    refute union_type === 1
    refute union_type === ''

    # == Kind::Class ==

    assert Kind.of_module?(Kind::Class)
    assert Kind.is?(Kind::Object, Kind::Class)
    assert Kind::Class.kind == ::Class
    assert Kind::Class.name == 'Class'
    assert Kind::Class?(String)
    assert Kind::Class?(String, Symbol)
    refute Kind::Class?(String, 1)

    # == Kind::Comparable ==

    assert Kind.of_module?(Kind::Comparable)
    assert Kind.is?(Kind::Object, Kind::Comparable)
    assert Kind::Comparable.kind == ::Comparable
    assert Kind::Comparable.name == 'Comparable'
    assert Kind::Comparable?('')
    assert Kind::Comparable?(1, '')
    refute Kind::Comparable?(1, [])

    # == Kind::Enumerable ==

    assert Kind.of_module?(Kind::Enumerable)
    assert Kind.is?(Kind::Object, Kind::Enumerable)
    assert Kind::Enumerable.kind == ::Enumerable
    assert Kind::Enumerable.name == 'Enumerable'
    assert Kind::Enumerable?([])
    assert Kind::Enumerable?([], {})
    refute Kind::Enumerable?(1, [])

    # == Kind::Enumerator ==

    assert Kind.of_module?(Kind::Enumerator)
    assert Kind.is?(Kind::Object, Kind::Enumerator)
    assert Kind::Enumerator.kind == ::Enumerator
    assert Kind::Enumerator.name == 'Enumerator'
    assert Kind::Enumerator?([].each)
    assert Kind::Enumerator?([].each, {}.each)
    refute Kind::Enumerator?(1, [].each)

    # == Kind::File ==
    file = File.new('.foo', 'w')

    assert Kind.of_module?(Kind::File)
    assert Kind.is?(Kind::Object, Kind::File)
    assert Kind::File.kind == ::File
    assert Kind::File.name == 'File'
    assert Kind::File?(file)
    assert Kind::File?(file, file)
    refute Kind::File?(file, [])

    # == Kind::Float ==

    assert Kind.of_module?(Kind::Float)
    assert Kind.is?(Kind::Object, Kind::Float)
    assert Kind::Float.kind == ::Float
    assert Kind::Float.name == 'Float'
    assert Kind::Float?(1.1)
    assert Kind::Float?(1.1, 2.0)
    refute Kind::Float?(1, 1.1)

    # == Kind::Hash ==

    assert Kind.of_module?(Kind::Hash)
    assert Kind.is?(Kind::Object, Kind::Hash)
    assert Kind::Hash.kind == ::Hash
    assert Kind::Hash.name == 'Hash'
    assert Kind::Hash?({})
    assert Kind::Hash?({}, {})
    refute Kind::Hash?(1, {})

    assert_equal({a: 1}, Kind::Hash.value_or_empty({a: 1}))
    assert_kind_of(::Hash, Kind::Hash.value_or_empty(1))
    assert_predicate(Kind::Hash.value_or_empty(1), :empty?)
    assert_predicate(Kind::Hash.value_or_empty(1), :frozen?)

    assert_equal(Kind::Hash.value_or_empty(nil), Kind::Hash.empty_or(nil))

    # == Kind::Integer ==

    assert Kind.of_module?(Kind::Integer)
    assert Kind.is?(Kind::Object, Kind::Integer)
    assert Kind::Integer.kind == ::Integer
    assert Kind::Integer.name == 'Integer'

    [
      [0, Kind::Integer.maybe(0)],
      [1, Kind::Integer.maybe { 1 }],
      [4, Kind::Integer.maybe(2) { |n| n * 2 }],
      [0, Kind::Integer.optional(0)],
      [1, Kind::Integer.optional { 1 }],
      [4, Kind::Integer.optional(2) { |n| n * 2 }]
    ].each do |expected, maybe|
      assert expected === maybe.value
    end

    [nil, Kind::Undefined, '', []].each do |value|
      [
        Kind::Integer.maybe(value),
        Kind::Integer.maybe { value },
        Kind::Integer.maybe(value) { |n| n },
        Kind::Integer.optional(value),
        Kind::Integer.optional { value },
        Kind::Integer.optional(value) { |n| n },
      ].each { |maybe| assert(maybe.none?, maybe.inspect) }
    end

    [
      Kind::Integer.maybe('2') { |v| v.to_i },
      Kind::Integer.optional('2') { |v| v.to_i },
    ].each { |maybe| assert(maybe.none?, maybe.inspect) }

    [
      Kind::Integer.maybe(2) { |v| v / 0 },
      Kind::Integer.optional(2) { |v| v / 0 },
      Kind::Integer.maybe { 2 / 0 },
      Kind::Integer.optional { 2 / 0 },
    ].each do |maybe|
      assert(maybe.none?, maybe.inspect)
      assert_instance_of(ZeroDivisionError, maybe.value, maybe.inspect)
    end

    assert_instance_of(Kind::Maybe::Typed, Kind::Integer.maybe)

    assert Kind::Integer.maybe[1].some?
    assert Kind::Integer.maybe.new(1).some?
    assert Kind::Integer.maybe.wrap(1).some?

    assert Kind::Integer?(1)
    assert Kind::Integer?(1, 2)
    refute Kind::Integer?(2, 1.0)

    # == Kind::IO ==

    assert Kind.of_module?(Kind::IO)
    assert Kind.is?(Kind::Object, Kind::IO)
    assert Kind::IO.kind == ::IO
    assert Kind::IO.name == 'IO'
    assert Kind::IO?(file)
    assert Kind::IO?(file, file)
    refute Kind::IO?(file, 0)

    # == Kind::Method ==

    assert Kind.of_module?(Kind::Method)
    assert Kind.is?(Kind::Object, Kind::Method)
    assert Kind::Method.kind == ::Method
    assert Kind::Method.name == 'Method'
    assert Kind::Method?(''.method(:upcase))
    assert Kind::Method?(''.method(:upcase), ''.method(:strip))
    refute Kind::Method?(''.method(:upcase), 0)

    # == Kind::Module ==

    assert Kind.of_module?(Kind::Module)
    assert Kind.is?(Kind::Object, Kind::Module)
    assert Kind::Module.kind == ::Module
    assert Kind::Module.name == 'Module'
    assert Kind::Module?(Enumerable)
    assert Kind::Module?(Enumerable, Comparable)
    refute Kind::Module?(Enumerable, 0)

    # == Kind::Numeric ==

    assert Kind.of_module?(Kind::Numeric)
    assert Kind.is?(Kind::Object, Kind::Numeric)
    assert Kind::Numeric.kind == ::Numeric
    assert Kind::Numeric.name == 'Numeric'
    assert Kind::Numeric?(1)
    assert Kind::Numeric?(1.0, 1)
    refute Kind::Numeric?('', 0)

    # == Kind::Proc ==

    assert Kind.of_module?(Kind::Proc)
    assert Kind.is?(Kind::Object, Kind::Proc)
    assert Kind::Proc.kind == ::Proc
    assert Kind::Proc.name == 'Proc'
    assert Kind::Proc?(proc {})
    assert Kind::Proc?(-> {}, proc {})
    refute Kind::Proc?(0, proc {})

    # == Kind::Queue ==

    assert Kind.of_module?(Kind::Queue)
    assert Kind.is?(Kind::Object, Kind::Queue)
    assert Kind::Queue.kind == ::Queue
    assert Kind::Queue.name == 'Queue'
    assert Kind::Queue?(::Queue.new)
    assert Kind::Queue?(::Queue.new, ::Queue.new)
    refute Kind::Queue?(0, ::Queue.new)

    # == Kind::Range ==

    assert Kind.of_module?(Kind::Range)
    assert Kind.is?(Kind::Object, Kind::Range)
    assert Kind::Range.kind == ::Range
    assert Kind::Range.name == 'Range'
    assert Kind::Range?(1..2)
    assert Kind::Range?(1..2, 1..3)
    refute Kind::Range?(1..3, 0)

    # == Kind::Regexp ==

    assert Kind.of_module?(Kind::Regexp)
    assert Kind.is?(Kind::Object, Kind::Regexp)
    assert Kind::Regexp.kind == ::Regexp
    assert Kind::Regexp.name == 'Regexp'
    assert Kind::Regexp?(/1/)
    assert Kind::Regexp?(/2/, /1/)
    refute Kind::Regexp?(/1/, 0)

    # == Kind::String ==

    assert Kind.of_module?(Kind::String)
    assert Kind.is?(Kind::Object, Kind::String)
    assert Kind::String.kind == ::String
    assert Kind::String.name == 'String'
    assert Kind::String?('1')
    assert Kind::String?('2', '1')
    refute Kind::String?('1', 0)

    assert_equal('1', Kind::String.value_or_empty('1'))
    assert_kind_of(::String, Kind::String.value_or_empty(1))
    assert_predicate(Kind::String.value_or_empty(1), :empty?)
    assert_predicate(Kind::String.value_or_empty(1), :frozen?)

    assert_equal(Kind::String.value_or_empty(nil), Kind::String.empty_or(nil))

    # == Kind::Struct ==

    struct = Struct.new(:a).new(1)

    assert Kind.of_module?(Kind::Struct)
    assert Kind.is?(Kind::Object, Kind::Struct)
    assert Kind::Struct.kind == ::Struct
    assert Kind::Struct.name == 'Struct'
    assert Kind::Struct?(struct)
    assert Kind::Struct?(struct, struct)
    refute Kind::Struct?(0, struct)

    # == Kind::Symbol ==

    assert Kind.of_module?(Kind::Symbol)
    assert Kind.is?(Kind::Object, Kind::Symbol)
    assert Kind::Symbol.kind == ::Symbol
    assert Kind::Symbol.name == 'Symbol'
    assert Kind::Symbol?(:a)
    assert Kind::Symbol?(:b, :a)
    refute Kind::Symbol?(:a, 0)

    # == Kind::Time ==

    time = Time.new

    assert Kind.of_module?(Kind::Time)
    assert Kind.is?(Kind::Object, Kind::Time)
    assert Kind::Time.kind == ::Time
    assert Kind::Time.name == 'Time'
    assert Kind::Time?(time)
    assert Kind::Time?(time, time)
    refute Kind::Time?(time, 0)
  end

  def test_the_custom_modules
    # == Kind::Boolean ==

    assert Kind.of_module?(Kind::Boolean)
    assert Kind.is?(Kind::Object, Kind::Boolean)
    assert Kind::Boolean.kind == [TrueClass, FalseClass]
    assert Kind::Boolean.name == 'Boolean'
    assert Kind::Boolean?(true)
    assert Kind::Boolean?(true, false)
    refute Kind::Boolean?(true, 1)

    # == Kind::Callable ==

    assert Kind.of_module?(Kind::Callable)
    assert Kind.is?(Kind::Object, Kind::Callable)
    assert_raises(NotImplementedError) { Kind::Callable.kind }
    assert Kind::Callable.name == 'Callable'
    assert Kind::Callable?(proc {})
    assert Kind::Callable?(-> {}, ''.method(:upcase))
    refute Kind::Callable?(-> {}, 1)

    # == Kind::ID ==

    assert Kind.of_module?(Kind::ID)
    assert Kind.is?(Kind::Object, Kind::ID)
    assert Kind::ID.kind == [Integer, String]
    assert Kind::ID.name == 'ID'
    assert Kind::ID?(12345)
    assert Kind::ID?('12345')
    assert Kind::ID?('e4379200-061c-11ec-9a03-0242ac130003')
    assert Kind::ID?('7dfea486-bd6e-423a-80ab-003dfec23933')
    refute Kind::ID?(0)
    refute Kind::ID?('0')
    refute Kind::ID?('12345t')
    refute Kind::ID?('123t45')
    refute Kind::ID?('t12345')
    refute Kind::ID?('e4379200-061c-11ec-9a03-0242ac13000')
    refute Kind::ID?('7dfea486-bd6e-423a-80ab-003dfec2393')

    # == Kind::Lambda ==

    assert Kind.of_module?(Kind::Lambda)
    assert Kind.is?(Kind::Object, Kind::Lambda)
    assert Kind::Lambda.kind == ::Proc
    assert Kind::Lambda.name == 'Lambda'
    assert Kind::Lambda?(-> {})
    assert Kind::Lambda?(-> {}, -> {})
    refute Kind::Lambda?(-> {}, proc {})
  end

  def test_the_stdlib_modules
    # == Kind::OpenStruct ==

    assert Kind.of_module?(Kind::OpenStruct)
    assert Kind.is?(Kind::Object, Kind::OpenStruct)
    assert Kind::OpenStruct.kind == ::OpenStruct
    assert Kind::OpenStruct.name == 'OpenStruct'
    assert Kind::OpenStruct?(OpenStruct.new)
    assert Kind::OpenStruct?(OpenStruct.new, OpenStruct.new)
    refute Kind::OpenStruct?(OpenStruct.new, 1)

    # == Kind::Set ==

    assert Kind.of_module?(Kind::Set)
    assert Kind.is?(Kind::Object, Kind::Set)
    assert Kind::Set.kind == ::Set
    assert Kind::Set.name == 'Set'
    assert Kind::Set?(Set.new)
    assert Kind::Set?(Set.new, Set.new)
    refute Kind::Set?(Set.new, [])

    set = Set.new([1])

    assert_equal(set, Kind::Set.value_or_empty(set))
    assert_kind_of(::Set, Kind::Set.value_or_empty([1]))
    assert_predicate(Kind::Set.value_or_empty(1), :empty?)
    assert_predicate(Kind::Set.value_or_empty(1), :frozen?)

    assert_equal(Kind::Set.value_or_empty(nil), Kind::Set.empty_or(nil))
  end

  def test_Kind_brackets
    kind_symbol1 = Kind[Symbol]

    assert_instance_of(Kind::Object::Instance, kind_symbol1)
    assert_equal('Symbol', kind_symbol1.name)

    # -

    kind_symbol2 = Kind[Symbol, name: 'MySymbol']

    assert_instance_of(Kind::Object::Instance, kind_symbol2)
    assert_equal('MySymbol', kind_symbol2.name)

    # -

    refute_same(kind_symbol1, kind_symbol2)
  end

  def test_Kind_Of
    assert Kind[Symbol].kind == Kind::Of(Symbol).kind
    assert Kind[Symbol].name == Kind::Of(Symbol).name
    assert Kind[Symbol].class == Kind::Of(Symbol).class
  end
end
