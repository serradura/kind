require 'test_helper'

class Kind::OfTypeCheckersTest < Minitest::Test
  # -- Class: String

  def test_if_the_object_is_a_kind_of_string
    assert_raises_kind_error(':a expected to be a kind of String') { Kind.of.String(:a) }
    assert_raises_kind_error('nil expected to be a kind of String') { Kind.of.String(nil) }

    # ---

    object = 'a'

    assert_same(object, Kind.of.String(object))

    assert_equal('default', Kind.of.String(nil, or: 'default'))

    # ---

    assert_raises_kind_error(':default expected to be a kind of String') { Kind.of.String(nil, or: :default) }
  end

  # -- Class: Symbol

  def test_if_the_object_is_a_kind_of_symbol
    assert_raises_kind_error('"a" expected to be a kind of Symbol') { Kind.of.Symbol('a') }
    assert_raises_kind_error('nil expected to be a kind of Symbol') { Kind.of.Symbol(nil) }

    # ---

    object = :a

    assert_same(object, Kind.of.Symbol(object))

    assert_equal(:default, Kind.of.Symbol(nil, or: :default))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Symbol') { Kind.of.Symbol(nil, or: 'default') }
  end

  # -- Class: Numeric

  def test_if_the_object_is_a_kind_of_numeric
    assert_raises_kind_error('"1" expected to be a kind of Numeric') { Kind.of.Numeric('1') }
    assert_raises_kind_error('nil expected to be a kind of Numeric') { Kind.of.Numeric(nil) }

    # ---

    object1 = 1
    object2 = 1.0

    assert_same(object1, Kind.of.Numeric(object1))
    assert_same(object2, Kind.of.Numeric(object2))

    assert_equal(1, Kind.of.Numeric(nil, or: 1))
    assert_equal(1.0, Kind.of.Numeric(nil, or: 1.0))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Numeric') { Kind.of.Numeric(nil, or: 'default') }
  end

  # -- Class: Integer

  def test_if_the_object_is_a_kind_of_integer
    assert_raises_kind_error('1.0 expected to be a kind of Integer') { Kind.of.Integer(1.0) }
    assert_raises_kind_error('nil expected to be a kind of Integer') { Kind.of.Integer(nil) }

    # ---

    object = 1

    assert_same(object, Kind.of.Integer(object))

    assert_equal(1, Kind.of.Integer(nil, or: 1))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Integer') { Kind.of.Integer(nil, or: 'default') }
  end

  # -- Class: Float

  def test_if_the_object_is_a_kind_of_float
    assert_raises_kind_error('1 expected to be a kind of Float') { Kind.of.Float(1) }
    assert_raises_kind_error('nil expected to be a kind of Float') { Kind.of.Float(nil) }

    # ---

    object = 1.0

    assert_same(object, Kind.of.Float(object))

    assert_equal(1.0, Kind.of.Float(nil, or: 1.0))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Float') { Kind.of.Float(nil, or: 'default') }
  end

  # -- Class: Regexp

  def test_if_the_object_is_a_kind_of_regexp
    assert_raises_kind_error('1 expected to be a kind of Regexp') { Kind.of.Regexp(1) }
    assert_raises_kind_error('nil expected to be a kind of Regexp') { Kind.of.Regexp(nil) }

    # ---

    object = /1.0/

    assert_same(object, Kind.of.Regexp(object))

    assert_equal(/2.0/, Kind.of.Regexp(nil, or: /2.0/))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Regexp') { Kind.of.Regexp(nil, or: 'default') }
  end

  # -- Class: Time

  def test_if_the_object_is_a_kind_of_time
    assert_raises_kind_error('1 expected to be a kind of Time') { Kind.of.Time(1) }
    assert_raises_kind_error('nil expected to be a kind of Time') { Kind.of.Time(nil) }

    # ---

    object = Time.now

    assert_same(object, Kind.of.Time(object))

    assert_equal(object, Kind.of.Time(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Time') { Kind.of.Time(nil, or: 'default') }
  end

  # -- Class: Array

  def test_if_the_object_is_a_kind_of_array
    assert_raises_kind_error('1 expected to be a kind of Array') { Kind.of.Array(1) }
    assert_raises_kind_error('nil expected to be a kind of Array') { Kind.of.Array(nil) }

    # ---

    object = []

    assert_same(object, Kind.of.Array(object))

    assert_equal([], Kind.of.Array(nil, or: []))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Array') { Kind.of.Array(nil, or: 'default') }
  end

  # -- Class: Range

  def test_if_the_object_is_a_kind_of_range
    assert_raises_kind_error('1 expected to be a kind of Range') { Kind.of.Range(1) }
    assert_raises_kind_error('nil expected to be a kind of Range') { Kind.of.Range(nil) }

    # ---

    object = 1..2

    assert_same(object, Kind.of.Range(object))

    assert_equal(2..3, Kind.of.Range(nil, or: 2..3))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Range') { Kind.of.Range(nil, or: 'default') }
  end

  # -- Class: Hash

  def test_if_the_object_is_a_kind_of_hash
    assert_raises_kind_error('[] expected to be a kind of Hash') { Kind.of.Hash([]) }
    assert_raises_kind_error('nil expected to be a kind of Hash') { Kind.of.Hash(nil) }

    # ---

    object = { a: 1 }

    assert_same(object, Kind.of.Hash(object))

    assert_equal({}, Kind.of.Hash(nil, or: {}))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Hash') { Kind.of.Hash(nil, or: 'default') }
  end

  # -- Class: Struct

  def test_if_the_object_is_a_kind_of_struct
    assert_raises_kind_error('[] expected to be a kind of Struct') { Kind.of.Struct([]) }
    assert_raises_kind_error('nil expected to be a kind of Struct') { Kind.of.Struct(nil) }

    # ---

    person = Struct.new(:name)

    object = person.new('John Doe')

    assert_same(object, Kind.of.Struct(object))

    assert_equal(object, Kind.of.Struct(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Struct') { Kind.of.Struct(nil, or: 'default') }
  end

  # -- Class: Enumerator

  def test_if_the_object_is_a_kind_of_enumerator
    assert_raises_kind_error('[] expected to be a kind of Enumerator') { Kind.of.Enumerator([]) }
    assert_raises_kind_error('nil expected to be a kind of Enumerator') { Kind.of.Enumerator(nil) }

    # ---

    object = [].each

    assert_same(object, Kind.of.Enumerator(object))

    assert_equal(object, Kind.of.Enumerator(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Enumerator') { Kind.of.Enumerator(nil, or: 'default') }
  end

  # -- Class: Set

  def test_if_the_object_is_a_kind_of_set
    assert_raises_kind_error('[] expected to be a kind of Set') { Kind.of.Set([]) }
    assert_raises_kind_error('nil expected to be a kind of Set') { Kind.of.Set(nil) }

    # ---

    object = Set.new

    assert_same(object, Kind.of.Set(object))

    assert_equal(object, Kind.of.Set(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Set') { Kind.of.Set(nil, or: 'default') }
  end

  # -- Class: Method

  def test_if_the_object_is_a_kind_of_method
    assert_raises_kind_error('[] expected to be a kind of Method') { Kind.of.Method([]) }
    assert_raises_kind_error('nil expected to be a kind of Method') { Kind.of.Method(nil) }

    # ---

    object = [1,2].method(:first)

    assert_same(object, Kind.of.Method(object))

    assert_equal(object, Kind.of.Method(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Method') { Kind.of.Method(nil, or: 'default') }
  end

  # -- Class: Proc

  def test_if_the_object_is_a_kind_of_proc
    assert_raises_kind_error('[] expected to be a kind of Proc') { Kind.of.Proc([]) }
    assert_raises_kind_error('nil expected to be a kind of Proc') { Kind.of.Proc(nil) }

    # ---

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_same(sum, Kind.of.Proc(sum))
    assert_same(sub, Kind.of.Proc(sub))

    assert_equal(sum, Kind.of.Proc(nil, or: sum))
    assert_equal(sub, Kind.of.Proc(nil, or: sub))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Proc') { Kind.of.Proc(nil, or: 'default') }
  end

  # -- Class: File

  def test_if_the_object_is_a_kind_of_file
    assert_raises_kind_error('[] expected to be a kind of File') { Kind.of.File([]) }
    assert_raises_kind_error('nil expected to be a kind of File') { Kind.of.File(nil) }

    # ---

    object = File.new('.foo', 'w')

    assert_same(object, Kind.of.File(object))

    assert_equal(object, Kind.of.File(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of File') { Kind.of.File(nil, or: 'default') }
  end

  # -- Custom: Boolean

  def test_if_the_object_is_a_kind_of_boolean
    assert_raises_kind_error('[] expected to be a kind of Boolean') { Kind.of.Boolean([]) }
    assert_raises_kind_error('nil expected to be a kind of Boolean') { Kind.of.Boolean(nil) }

    # ---

    assert_same(true, Kind.of.Boolean(true))
    assert_same(false, Kind.of.Boolean(false))

    assert_same(true, Kind.of.Boolean(nil, or: true))
    assert_same(false, Kind.of.Boolean(nil, or: false))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Boolean') { Kind.of.Boolean(nil, or: 'default') }
  end

  # -- Custom: Callable

  def test_if_the_object_is_a_kind_of_callable
    assert_raises_kind_error('[] expected to be a kind of Callable') { Kind.of.Callable([]) }
    assert_raises_kind_error('nil expected to be a kind of Callable') { Kind.of.Callable(nil) }

    # ---

    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    assert_same(sum, Kind.of.Callable(sum))
    assert_same(sum, Kind.of.Callable(nil, or: sum))

    assert_same(sub, Kind.of.Callable(sub))
    assert_same(sub, Kind.of.Callable(nil, or: sub))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Callable') { Kind.of.Callable(nil, or: 'default') }
  end

  # -- Custom: Lambda

  def test_if_the_object_is_a_kind_of_lambda
    sum = proc { |a, b| a + b }
    sub = lambda { |a, b| a - b }

    # ---

    assert_raises_kind_error('[] expected to be a kind of Lambda') { Kind.of.Lambda([]) }
    assert_raises_kind_error('nil expected to be a kind of Lambda') { Kind.of.Lambda(nil) }
    assert_raises_kind_error(/<Proc:.*> expected to be a kind of Lambda/) { Kind.of.Lambda(sum) }

    # ---

    assert_same(sub, Kind.of.Lambda(sub))

    assert_equal(sub, Kind.of.Lambda(nil, or: sub))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Lambda') { Kind.of.Lambda(nil, or: 'default') }
  end

  # -- Class: Queue

  def test_if_the_object_is_a_kind_of_queue
    assert_raises_kind_error('[] expected to be a kind of Thread::Queue') { Kind.of.Queue([]) }
    assert_raises_kind_error('nil expected to be a kind of Thread::Queue') { Kind.of.Queue(nil) }

    # ---

    object = Queue.new

    assert_same(object, Kind.of.Queue(object))

    assert_equal(object, Kind.of.Queue(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Thread::Queue') { Kind.of.Queue(nil, or: 'default') }
  end

  # -- Class: Kind::Maybe

  def test_if_the_object_is_a_kind_of_maybe
    assert_raises_kind_error('[] expected to be a kind of Kind::Maybe::Result') { Kind.of.Maybe([]) }
    assert_raises_kind_error('nil expected to be a kind of Kind::Maybe::Result') { Kind.of.Maybe(nil) }

    # ---

    some = Kind::Maybe[1]
    none = Kind::Maybe[nil]

    assert_same(some, Kind.of.Maybe(some))
    assert_equal(some, Kind.of.Maybe(nil, or: some))

    assert_same(none, Kind.of.Maybe(none))
    assert_equal(none, Kind.of.Maybe(nil, or: none))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Kind::Maybe::Result') { Kind.of.Maybe(nil, or: 'default') }
  end

  def test_if_the_object_is_a_kind_of_optional
    assert_raises_kind_error('[] expected to be a kind of Kind::Maybe::Result') { Kind.of.Optional([]) }
    assert_raises_kind_error('nil expected to be a kind of Kind::Maybe::Result') { Kind.of.Optional(nil) }

    # ---

    some = Kind::Optional[1]
    none = Kind::Optional[nil]

    assert_same(some, Kind.of.Optional(some))
    assert_equal(some, Kind.of.Optional(nil, or: some))

    assert_same(none, Kind.of.Optional(none))
    assert_equal(none, Kind.of.Optional(nil, or: none))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Kind::Maybe::Result') { Kind.of.Optional(nil, or: 'default') }
  end

  # -- Module: Enumerable

  def test_if_the_object_is_a_kind_of_enumerable
    assert_raises_kind_error('1 expected to be a kind of Enumerable') { Kind.of.Enumerable(1) }
    assert_raises_kind_error('nil expected to be a kind of Enumerable') { Kind.of.Enumerable(nil) }

    # ---

    object = []

    assert_same(object, Kind.of.Enumerable(object))

    assert_equal(object, Kind.of.Enumerable(nil, or: object))

    # ---

    assert_raises_kind_error('"default" expected to be a kind of Enumerable') { Kind.of.Enumerable(nil, or: 'default') }
  end

  # -- Module: Comparable

  def test_if_the_object_is_a_kind_of_comparable
    assert_raises_kind_error('[] expected to be a kind of Comparable') { Kind.of.Comparable([]) }
    assert_raises_kind_error('nil expected to be a kind of Comparable') { Kind.of.Comparable(nil) }

    # ---

    object = 'a'

    assert_same(object, Kind.of.Comparable(object))

    assert_equal(object, Kind.of.Comparable(nil, or: object))

    # ---

    assert_raises_kind_error('[] expected to be a kind of Comparable') { Kind.of.Comparable(nil, or: []) }
  end
end
