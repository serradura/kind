require 'test_helper'

class Kind::UnionTypeTest < Minitest::Test
  def test_the_union_type_builder
    union_type1 = Kind::UnionType.new(::Array) | Kind::Nil
    union_type2 = Kind::Array | Kind::Nil
    union_type3 = Kind::Array | nil

    [union_type1, union_type2, union_type3].each do |union_type|
      assert '(Array | nil)' == union_type.name
      assert '(Array | nil)' == union_type.inspect

      assert union_type === []
      assert union_type === nil

      assert [] == union_type[[]]
      assert nil == union_type[nil]

      assert_raises_with_message(
        Kind::Error,
        '1 expected to be a kind of (Array | nil)'
      ) { union_type[1] }
    end
  end

  def test_assert_hash_schema
    h1 = {hash: {}, array: []}

    # --

    hash_or_array = Kind::Array | Hash

    assert_equal(h1, Kind.assert_hash!(h1, schema: {
      hash: hash_or_array,
      array: hash_or_array
    }))
  end
end
