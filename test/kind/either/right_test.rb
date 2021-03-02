require 'test_helper'

class Kind::EitherRightTest < Minitest::Test
  require 'kind/either'

  def test_the_either_constructor
    assert Kind::Either::Right === Kind::Either[1]
    assert Kind::Either::Right === Kind::Either.new(1)
  end

  def test_the_either_right
    either = Kind::Right(2)

    assert_equal(2, either.value)

    assert_equal('#<Kind::Right value=2>', either.inspect)

    refute either.left?
    assert either.right?

    assert either.map { |n| Kind::Left(n - 2) }.left?
    assert either.map { |n| Kind::Right(n + 2) }.right?

    assert_equal(0, either.map { |n| Kind::Left(n - 2) }.value)
    assert_equal(4, either.map { |n| Kind::Right(n + 2) }.value)

    assert_raises_with_message(
      Kind::Error,
      '4 expected to be a kind of Kind::Right | Kind::Left'
    ) { either.map { |n| n + 2 } }

    assert either.then { |n| Kind::Left(n - 2) }.left?
    assert either.then { |n| Kind::Right(n + 2) }.right?

    assert_equal(0, either.then { |n| Kind::Left(n - 2) }.value)
    assert_equal(4, either.then { |n| Kind::Right(n + 2) }.value)

    assert_raises_with_message(
      Kind::Error,
      '4 expected to be a kind of Kind::Right | Kind::Left'
    ) { either.then { |n| n + 2 } }

    assert_equal(2, either.value_or)
    assert_equal(2, either.value_or(3))
    assert_equal(2, either.value_or { 4 })

    assert_same(either, either.on_left { raise RuntimeError })
    assert_same(either, either.on_right {})

    count = 0

    either
      .on_right { |n| count += n }
      .on_left { raise RuntimeError }
      .on_right { |n| count += n }

    assert_equal(4, count)

    assert_nil(either.on {})
    assert_nil(either.on { |result| result.left {} })
    assert_equal(3, either.on do |result|
      result.right { |value| value + 1 }
      result.left { |value| value - 1 }
    end)
  end

  def test_the_case_equality
    success = Kind::Right(1)

    count = 0

    case success
    when Kind::Right(2)       then count -= 1
    when Kind::Right(Numeric) then count += 1
    end

    case success
    when Kind::Right(1)       then count += 1
    when Kind::Right(Numeric) then count -= 1
    end

    assert_equal(2, count)
  end
end
