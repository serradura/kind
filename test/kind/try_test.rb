require 'test_helper'

class Kind::TryTest < Minitest::Test
  def test_the_calling_of_a_method_if_the_given_object_respond_to_it
    assert_equal('foo', Kind::Try.(' foo ', :strip))
    assert_equal(1, Kind::Try.({a: 1}, :[], :a))
    assert_equal(2, Kind::Try.({a: 1}, :fetch, :b, 2))
    assert_nil(Kind::Try.({a: 1}, :[], :b))

    # FACT: Returns nil if the object doesn't respond to the method
    assert_nil(Kind::Try.(:symbol, :strip))

    # FACT: Returns nil if the object is nil or Kind::Undefined
    assert_nil(Kind::Try.(nil, :strip))
    assert_nil(Kind::Try.(Kind::Undefined, :strip))

    # FACT: Raises an exception if the method name isn't a string or a symbol
    assert_raises_with_message(
      TypeError,
      '1 is not a symbol nor a string',
    ) { Kind::Try.({a: 1}, 1, :a) }
  end
end
