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

    assert_same(either, either.on_left { raise })
    assert_same(either, either.on_right {})

    count = 0

    either
      .on_right { |n| count += n }
      .on_left { raise }
      .on_right { |n| count += n }
      .on_right(Float) { raise }
      .on_right(Numeric) { |n| count += n }

    assert_equal(6, count)

    assert_nil(either.on {})
    assert_nil(either.on { |result| result.left {} })

    assert_equal(3, either.on do |result|
      result.right { |value| value + 1 }
      result.left { raise }
    end)

    assert_equal(3, either.on do |result|
      result.left(Numeric) { raise }
      result.right(Float) { raise }
      result.right(Numeric) { |value| value + 1 }
      result.left { raise }
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

  def test_error_handling
    [
      Kind::Right(0).map { |n| Kind::Right(2 / n) },
      Kind::Right(0).then { |n| Kind::Right(2 / n) }
    ].each do |result|
      assert ZeroDivisionError === result.value
    end

    assert_raises_with_message(
      Kind::Monad::WrongOutput,
      '2 expected to be a kind of Kind::Right | Kind::Left'
    ) { Kind::Right(0).map { |n| n + 2 } }

    assert_raises_with_message(
      Kind::Monad::WrongOutput,
      '3 expected to be a kind of Kind::Right | Kind::Left'
    ) { Kind::Right(0).then { |n| n + 3 } }

    assert_raises_with_message(
      ZeroDivisionError,
      'divided by 0'
    ) { Kind::Right(0).map! { |n| Kind::Right(2 / n) } }

    assert_raises_with_message(
      ZeroDivisionError,
      'divided by 0'
    ) { Kind::Right(0).then! { |n| Kind::Right(2 / n) } }
  end
end
