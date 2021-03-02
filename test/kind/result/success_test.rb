require 'test_helper'

class Kind::ResultSuccessTest < Minitest::Test
  require 'kind/result'

  def test_the_kind_result_constructor
    assert Kind::Result::Success === Kind::Result[1]
    assert Kind::Result::Success === Kind::Result.new(1)
  end

  def test_the_result_success
    result = Kind::Success(2)

    assert_equal(2, result.value)

    assert_equal('#<Kind::Success value=2>', result.inspect)

    refute result.failed?
    refute result.failure?
    assert result.success?
    assert result.succeeded?

    assert :ok == result.type

    assert result.map { |n| Kind::Failure(n - 2) }.failure?
    assert result.map { |n| Kind::Success(n + 2) }.success?

    assert_equal(0, result.map { |n| Kind::Failure(n - 2) }.value)
    assert_equal(4, result.map { |n| Kind::Success(n + 2) }.value)

    assert_raises_with_message(
      Kind::Error,
      '4 expected to be a kind of Kind::Success | Kind::Failure'
    ) { result.map { |n| n + 2 } }

    assert result.then { |n| Kind::Failure(n - 2) }.failure?
    assert result.then { |n| Kind::Success(n + 2) }.success?

    assert_equal(0, result.then { |n| Kind::Failure(n - 2) }.value)
    assert_equal(4, result.then { |n| Kind::Success(n + 2) }.value)

    assert_raises_with_message(
      Kind::Error,
      '4 expected to be a kind of Kind::Success | Kind::Failure'
    ) { result.then { |n| n + 2 } }

    assert_equal(2, result.value_or)
    assert_equal(2, result.value_or(3))
    assert_equal(2, result.value_or { 4 })

    assert_same(result, result.on_failure { raise RuntimeError })
    assert_same(result, result.on_success {})
  end

  def test_the_success_builder
    result1 = Kind::Success(:valid)

    assert result1.success?

    assert :ok == result1.type
    assert :valid == result1.value

    # --

    result2 = Kind::Success(:valid, true)

    assert result2.success?

    assert :valid == result2.type
    assert true == result2.value

    # --

    assert_raises_with_message(
      Kind::Error,
      '"valid" expected to be a kind of Symbol'
    ) { Kind::Success('valid', true) }

    # --

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 0, expected 1 or 2)'
    ) { Kind::Success() }
  end

  def test_the_success_hook
    result = Kind::Success(2)

    count = 0

    result
      .on_success { |n| count += n }
      .on_failure { raise RuntimeError }
      .on_success(:ok) { |n| count += n }
      .on_success(:valid, :ok) { |n| count += n }
      .on_success { |n| count += n }

    assert_equal(8, count)

    # --

    assert_nil(result.on {})
    assert_nil(result.on { |_| _.failure {} })

    assert_equal(3, result.on do |_|
      _.success { |value| value + 1 }
      _.failure { |value| value - 1 }
    end)

    assert_equal(3, result.on do |_|
      _.success(:ok) { |value| value + 1 }
      _.failure { |value| value - 1 }
    end)

    assert_equal(3, result.on do |_|
      _.success(:valid, :ok) { |value| value + 1 }
      _.failure { |value| value - 1 }
    end)

    assert_equal(4, result.on do |_|
      _.success { |value| value + 2 }
      _.success(:valid, :ok) { |value| value + 1 }
      _.failure { |value| value - 1 }
    end)

    assert_nil(result.on do |_|
      _.success(:bar) { |value| value + 2 }
      _.success(:foo) { |value| value + 1 }
    end)
  end

  def test_the_case_equality
    success = Kind::Success(:valid, 1)

    count = 0

    case success
    when Kind::Success(Numeric)         then count -= 1
    when Kind::Success(:valid, 2)       then count -= 1
    when Kind::Success(:valid, Numeric) then count += 1
    end

    case success
    when Kind::Success(Numeric)   then count -= 1
    when Kind::Success(:valid, 1) then count += 1
    end

    assert_equal(2, count)
  end
end
