require 'test_helper'

class Kind::OfModulesTest < Minitest::Test
  def test_the_kind_of_hash_method
    refute Kind.of.Hash.instance?('')
    assert Kind.of.Hash.instance?({})

    assert Kind.of.Hash.class?(Hash)
    assert Kind.of.Hash.class?(Class.new(Hash))

    assert_nil Kind.of.Hash.or_nil('')
    assert_equal({a: 1}, Kind.of.Hash.or_nil(a: 1))

    # ---

    refute Kind::Of::Hash.instance?('')
    assert Kind::Of::Hash.instance?({})

    refute Kind::Of::Hash.class?(String)
    assert Kind::Of::Hash.class?(Hash)
    assert Kind::Of::Hash.class?(Class.new(Hash))

    assert_nil Kind::Of::Hash.or_nil('')
    assert_equal({a: 1}, Kind::Of::Hash.or_nil(a: 1))
  end

  def test_if_a_value_is_a_kind_of_string
    refute Kind.of.String.instance?({})
    assert Kind.of.String.instance?('')

    refute Kind.of.String.class?(Hash)
    assert Kind.of.String.class?(String)
    assert Kind.of.String.class?(Class.new(String))

    assert_nil Kind.of.String.or_nil({})
    assert_equal('a', Kind.of.String.or_nil('a'))

    # ---

    refute Kind::Of::String.instance?({})
    assert Kind::Of::String.instance?('')

    refute Kind::Of::String.class?(Hash)
    assert Kind::Of::String.class?(String)
    assert Kind::Of::String.class?(Class.new(String))

    assert_nil Kind::Of::String.or_nil({})
    assert_equal('a', Kind::Of::String.or_nil('a'))
  end
end
