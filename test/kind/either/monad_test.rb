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
    assert_raises(NotImplementedError) { either.map! { 0 } }
    assert_raises(NotImplementedError) { either.then { 0 } }
    assert_raises(NotImplementedError) { either.then! { 0 } }
    assert_raises(NotImplementedError) { either.and_then { 0 } }
    assert_raises(NotImplementedError) { either.and_then! { 0 } }
    assert_raises(NotImplementedError) { either.value_or(2) }
    assert_raises(NotImplementedError) { either.value_or { 3 } }

    assert_nil(either.on {})
    assert_nil(either.on { |result| result.left {} })
    assert_nil(either.on { |result| result.right {} })
  end

  def test_the_from_method
    right1 = Kind::Either.from { 1 }
    right2 = Kind::Either.from { Kind::Right(3) }

    left1 = Kind::Either.from { 2 / 0 }
    left2 = Kind::Either.from { Kind::Left(4) }

    assert right1.right?
    assert right1.value == 1

    assert right2.right?
    assert right2.value == 3

    assert left1.left?
    assert_instance_of(ZeroDivisionError, left1.value)

    assert left2.left?
    assert left2.value == 4
  end

  def test_the_and_then_method
    right = Kind::Right(1)

    assert right.method(:map) == right.method(:and_then)
    assert right.method(:map) == right.method(:then)
    assert right.method(:map!) == right.method(:then!)
    assert right.method(:map!) == right.method(:and_then!)

    left = Kind::Left(0)

    assert left.method(:map) == left.method(:then)
    assert left.method(:map) == left.method(:and_then)
    assert left.method(:map!) == left.method(:then!)
    assert left.method(:map!) == left.method(:and_then!)
  end
end
