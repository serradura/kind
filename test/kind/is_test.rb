require 'test_helper'

class Kind::IsTest < Minitest::Test
  def test_if_a_value_is_a_hash_class_or_subclass
    refute Kind.is.Hash(Object)

    my_hash = Class.new(Hash)

    assert Kind.is.Hash(Hash)
    assert Kind.is.Hash(my_hash)
  end

  def test_if_a_value_is_a_string_class_or_subclass
    refute Kind.is.String(Object)

    my_string = Class.new(String)

    assert Kind.is.String(String)
    assert Kind.is.String(my_string)
  end

  def test_the_is_a_method
    assert_equal(Kind.is.String(Object), Kind.is_a.String(Object))

    my_string = Class.new(String)

    assert_equal(Kind.is.String(String), Kind.is_a.String(String))
    assert_equal(Kind.is.String(my_string), Kind.is_a.String(my_string))
  end
end
