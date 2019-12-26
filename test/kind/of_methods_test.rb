require 'test_helper'

class Kind::OfMethodsTest < Minitest::Test
  def test_if_a_value_is_a_kind_of_hash
    assert_raises(Kind::Error) { Kind.of.Hash(Object.new) }

    value = {a: 1}

    assert_same(value, Kind.of.Hash(value))
  end

  def test_if_a_value_is_a_kind_of_string
    assert_raises(Kind::Error) { Kind.of.String(Object.new) }

    value = 'a'

    assert_same(value, Kind.of.String(value))
  end
end
