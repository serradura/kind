require 'test_helper'

class Kind::EitherLeftTest < Minitest::Test
  require 'kind/either'

  def test_the_either_left
    either = Kind::Left(1)

    assert_equal(1, either.value)

    assert_equal('#<Kind::Left value=1>', either.inspect)

    assert either.left?
    refute either.right?

    assert_equal(1, either.map { |n| n + 2 }.value)
    assert_equal(1, either.map { |n| Kind::Right(n + 2) }.value)

    assert_equal(1, either.then { |n| n + 2 }.value)
    assert_equal(1, either.then { |n| Kind::Right(n + 2) }.value)

    assert_equal(2, either.value_or(2))
    assert_equal(3, either.value_or { 3 })

    assert_equal(1, either.value_or { |value| value })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { either.value_or }

    assert_same(either, either.on_left {})
    assert_same(either, either.on_right { raise })

    count = 0

    either
      .on_left { |n| count += n }
      .on_right { raise }
      .on_left { |n| count += n }
      .on_left(Float) { raise }
      .on_left(Numeric) { |n| count += n }

    assert_equal(3, count)

    assert_nil(either.on {})
    assert_nil(either.on { |result| result.right {} })

    assert_equal(0, either.on do |result|
      result.left { |value| value - 1 }
      result.right { |value| raise }
    end)

    assert_equal(0, either.on do |result|
      result.left(Float) { raise }
      result.right(Numeric) { raise }
      result.left(Numeric) { |value| value - 1 }
      result.right { |value| raise }
    end)
  end

  def test_the_case_equality
    success = Kind::Left(0)

    count = 0

    case success
    when Kind::Left(2)       then count -= 1
    when Kind::Left(Numeric) then count += 1
    end

    case success
    when Kind::Left(0)       then count += 1
    when Kind::Left(Numeric) then count -= 1
    end

    assert_equal(2, count)
  end
end
