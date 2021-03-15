require 'test_helper'

class Kind::UnionNilTest < Minitest::Test
  def test_name
    assert 'nil' == Kind::Nil.name
  end

  def test_the_equality
    assert Kind::Nil === nil
    refute Kind::Nil === 1
  end

  def test_the_union_type_builder
    nil_or_array = Kind::Nil | Kind::Array

    assert nil_or_array === nil
    assert nil_or_array === []

    refute nil_or_array === 1
  end
end
