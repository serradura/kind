require 'test_helper'

class Kind::EitherMonadTest < Minitest::Test
  require 'kind/either'

  def test_the_either_monad
    object = Object.new

    either = Kind::Either::Monad[object]

    assert_same(object, either.value)

    refute either.left?
    refute either.right?

    assert_same(either, either.on_left {})
    assert_same(either, either.on_right {})

    assert_raises(NotImplementedError) { either.map { 0 } }
    assert_raises(NotImplementedError) { either.then { 0 } }
    assert_raises(NotImplementedError) { either.value_or(2) }
    assert_raises(NotImplementedError) { either.value_or { 3 } }

    assert_nil(either.on {})
    assert_nil(either.on { |result| result.left {} })
    assert_nil(either.on { |result| result.right {} })
  end
end
