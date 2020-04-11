require 'test_helper'

class Kind::IsClassTest < Minitest::Test
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
