require 'test_helper'

class Bar
end

module Foo
  class Bar
  end
end

class Kind::OfTest < Minitest::Test
  def setup
    @bar = Bar.new
    @foo_bar = Foo::Bar.new
  end

  def test_the_method_call
    assert_same(1, Kind::Of.call(Numeric, 1))
    assert_same(@bar, Kind::Of.call(Bar, @bar))
    assert_same(@foo_bar, Kind::Of.call(Foo::Bar, @foo_bar))

    assert_raises_kind_error(given: '"1"', expected: 'Numeric') { Kind::Of.call(Numeric, '1') }
    assert_raises_kind_error(given: '"1"', expected: 'Bar') { Kind::Of.call(Bar, '1') }
    assert_raises_kind_error(given: '"1"', expected: 'Foo::Bar') { Kind::Of.call(Foo::Bar, '1') }
  end

  def test_the_kind_is_method
    assert_same(Kind::Of, Kind.of)

    # ---

    assert_same(1, Kind.of(Numeric, 1))
    assert_same(@bar, Kind.of(Bar, @bar))
    assert_same(@foo_bar, Kind.of(Foo::Bar, @foo_bar))

    assert_raises_kind_error(given: '"1"', expected: 'Numeric') { Kind.of(Numeric, '1') }
    assert_raises_kind_error(given: '"1"', expected: 'Bar') { Kind.of(Bar, '1') }
    assert_raises_kind_error(given: '"1"', expected: 'Foo::Bar') { Kind.of(Foo::Bar, '1') }

    # ---

    kind_of_bar = Kind.of(Bar)

    assert_raises_kind_error(given: 'nil', expected: 'Bar') { kind_of_bar.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Bar') { kind_of_bar.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Bar') { kind_of_bar.instance(:a) }
    assert_equal(@bar, kind_of_bar.instance(@bar))
    assert_equal(@bar, kind_of_bar.instance(:a, or: @bar))
    assert_equal(@bar, kind_of_bar.instance(nil, or: @bar))
    assert_equal(@bar, kind_of_bar.instance(Kind::Undefined, or: @bar))
    assert_raises_kind_error(given: 'nil', expected: 'Bar') { kind_of_bar.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Bar') { kind_of_bar.instance(Kind::Undefined, or: nil) }

    refute kind_of_bar.instance?({})
    assert kind_of_bar.instance?(@bar)

    assert_equal(false, kind_of_bar.class?(Hash))
    assert_equal(true, kind_of_bar.class?(Bar))
    assert_equal(true, kind_of_bar.class?(Class.new(Bar)))

    assert_nil kind_of_bar.or_nil({})
    assert_equal(@bar, kind_of_bar.or_nil(@bar))

    assert_kind_undefined kind_of_bar.or_undefined({})
    assert_equal(@bar, kind_of_bar.or_undefined(@bar))

    assert_same(kind_of_bar, Kind.of(Bar))

    assert_instance_of(Kind::Checker, kind_of_bar)

    kind_of_bar.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([@bar, {}], kind_of_bar[@bar])
    end

    # ---

    kind_of_foo_bar = Kind.of(Foo::Bar)

    assert_raises_kind_error(given: 'nil', expected: 'Foo::Bar') { kind_of_foo_bar.instance(nil) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Foo::Bar') { kind_of_foo_bar.instance(Kind::Undefined) }
    assert_raises_kind_error(given: ':a', expected: 'Foo::Bar') { kind_of_foo_bar.instance(:a) }
    assert_equal(@foo_bar, kind_of_foo_bar.instance(@foo_bar))
    assert_equal(@foo_bar, kind_of_foo_bar.instance(:a, or: @foo_bar))
    assert_equal(@foo_bar, kind_of_foo_bar.instance(nil, or: @foo_bar))
    assert_equal(@foo_bar, kind_of_foo_bar.instance(Kind::Undefined, or: @foo_bar))
    assert_raises_kind_error(given: 'nil', expected: 'Foo::Bar') { kind_of_foo_bar.instance(nil, or: Kind::Undefined) }
    assert_raises_kind_error(given: 'Kind::Undefined', expected: 'Foo::Bar') { kind_of_foo_bar.instance(Kind::Undefined, or: nil) }

    refute kind_of_foo_bar.instance?({})
    assert kind_of_foo_bar.instance?(@foo_bar)

    assert_equal(false, kind_of_foo_bar.class?(Hash))
    assert_equal(true, kind_of_foo_bar.class?(Foo::Bar))
    assert_equal(true, kind_of_foo_bar.class?(Class.new(Foo::Bar)))

    assert_nil kind_of_foo_bar.or_nil({})
    assert_equal(@foo_bar, kind_of_foo_bar.or_nil(@foo_bar))

    assert_kind_undefined kind_of_foo_bar.or_undefined({})
    assert_equal(@foo_bar, kind_of_foo_bar.or_undefined(@foo_bar))

    assert_same(kind_of_foo_bar, Kind.of(Foo::Bar))

    assert_instance_of(Kind::Checker, kind_of_foo_bar)

    kind_of_foo_bar.stub(:instance, -> (obj, opt) { [obj, opt] }) do
      assert_equal([@foo_bar, {}], kind_of_foo_bar[@foo_bar])
    end

    # ---

    assert_same(Kind::Of::String, Kind.of(String))
  end
end
