require 'test_helper'

class Kind::IsClassTest < Minitest::Test
  def test_if_a_value_is_a_module
    assert_kind_is(:Module, Module, Enumerable, Comparable)

    refute_kind_is(:Module, Class, Object)
  end

  def test_if_a_value_is_an_enumerable_module
    assert_kind_is(:Enumerable, Enumerable, Module.new { extend(Enumerable) })

    refute_kind_is(:Enumerable, Comparable, Module)
  end

  def test_if_a_value_is_a_comparable_module
    assert_kind_is(:Comparable, Comparable, Module.new { extend(Comparable) })

    refute_kind_is(:Comparable, Enumerable, Module)
  end
end
