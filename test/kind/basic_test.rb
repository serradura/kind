require 'test_helper'

class Kind::KindTest < Minitest::Test
  class MyArray < Array
  end

  def test_Kind_is?
    # FACT: Can check if the given value is the class or a subclass of the expected kind
    assert Kind.is?(Class, Array)
    assert Kind.is?(Array, Array)
    assert Kind.is?(Array, MyArray)
    refute Kind.is?(Module, Array)

    # FACT: Can check if the given value extend or include the expected module
    assert Kind.is?(Enumerable, Enumerable)
    assert Kind.is?(Enumerable, Array)
    assert Kind.is?(Module, Enumerable)
    refute Kind.is?(Class, Enumerable)

    # FACT: Raises an exception if the kind isn't a class or module
    assert_raises_with_message(
      Kind::Error,
      '"1" expected to be a kind of Module/Class'
    ) { Kind.is?('1', String) }

    # FACT: Raises an exception if the value isn't a class or module
    assert_raises_with_message(
      Kind::Error,
      '"2" expected to be a kind of Module/Class'
    ) { Kind.is?(String, '2') }
  end

  def test_Kind_is
    # FACT: Can check if the given value is the class or a subclass of the expected kind
    assert Kind.is(Class, Array)
    assert Kind.is(Array, Array)
    assert Kind.is(Array, MyArray)
    refute Kind.is(Module, Array)

    # FACT: Can check if the given value extend or include the expected module
    assert Kind.is(Enumerable, Enumerable)
    assert Kind.is(Enumerable, Array)
    assert Kind.is(Module, Enumerable)
    refute Kind.is(Class, Enumerable)

    # FACT: Raises an exception if the kind isn't a class or module
    assert_raises_with_message(
      Kind::Error,
      '"1" expected to be a kind of Module/Class'
    ) { Kind.is('1', String) }

    # FACT: Raises an exception if the value isn't a class or module
    assert_raises_with_message(
      Kind::Error,
      '"2" expected to be a kind of Module/Class'
    ) { Kind.is(String, '2') }
  end

  def test_Kind_is!
    assert Array == Kind.is!(Class, Array)
    assert Array == Kind.is!(Array, Array)

    assert Array == Kind.is!(Enumerable, Array)
    assert Enumerable == Kind.is!(Enumerable, Enumerable)
    assert Enumerable == Kind.is!(Module, Enumerable)

    assert_raises_with_message(
      Kind::Error,
      'Enumerable expected to be a Class'
    ) { Kind.is!(Class, Enumerable) }

    assert_raises_with_message(
      Kind::Error,
      'Foo#bar: Enumerable expected to be a Class'
    ) { Kind.is!(Class, Enumerable, label: 'Foo#bar') }
  end

  def test_Kind_of?
    # FACT: Can check one instance
    assert Kind.of?(Array, [])
    refute Kind.of?(Array, nil)

    # FACT: Can check multiple instances
    assert Kind.of?(Enumerable, [], {})
    assert Kind.of?(Hash, {}, {})
    refute Kind.of?(Array, [], nil)

    # FACT: Returns a lambda that knows how to check instances when it only receives the kind.
    is_string = Kind.of?(String)

    assert_instance_of(Proc, is_string)
    assert_predicate(is_string, :lambda?)

    assert is_string.call('1')
    refute is_string.call(nil)
  end

  def test_Kind_respond_to?
    assert Kind.respond_to?({}, :[])
    assert Kind.respond_to?({}, :[], :fetch)
    refute Kind.respond_to?({}, :[], :fetch, :foo)
    refute Kind.respond_to?('', :fetch)

    # --

    assert Kind.respond_to?(:is)
    assert Kind.respond_to?(:is?)
    refute Kind.respond_to?(:foo)
  end

  def test_Kind_of_class?
    # FACT: Can check if the given value is a class
    assert Kind.of_class?(Array)

    refute Kind.of_class?(Enumerable)
    refute Kind.of_class?(nil)
    refute Kind.of_class?(1)
  end

  def test_Kind_of_module?
    # FACT: Can check if the given value is a module
    assert Kind.of_module?(Enumerable)

    refute Kind.of_module?(String)
    refute Kind.of_module?(nil)
    refute Kind.of_module?(1)
  end

  def test_Kind_respond_to
    assert_equal('', Kind.respond_to('', :upcase))
    assert_equal('', Kind.respond_to('', :upcase, :strip))

    # -

    assert_raises_with_message(
      Kind::Error,
      'expected 1 to respond to :upcase'
    ) { Kind.respond_to(1, :upcase) }

    assert_raises_with_message(
      Kind::Error,
      'expected 2 to respond to :upcase'
    ) { Kind.respond_to(2, :to_s, :upcase) }
  end

  def test_Kind_of_module_or_class
    # FACT: Returns the given value if it is a class or module
    assert_equal(Class, Kind.of_module_or_class(Class))
    assert_equal(Array, Kind.of_module_or_class(Array))
    assert_equal(Module, Kind.of_module_or_class(Module))
    assert_equal(Enumerable, Kind.of_module_or_class(Enumerable))

    # FACT: Raises an exception if the kind isn't a class or module
    assert_raises_with_message(
      Kind::Error,
      '"1" expected to be a kind of Module/Class'
    ) { Kind.of_module_or_class('1') }
  end

  def test_Kind_value
    assert '1' == Kind.value(String, '1', default: '')

    assert '' == Kind.value(String, 1, default: '')

    # FACT: The default value must be of the expected kind.
    assert_raises_with_message(
      Kind::Error,
      '2 expected to be a kind of String'
    ) { Kind.value(String, 1, default: 2) }
  end
end
