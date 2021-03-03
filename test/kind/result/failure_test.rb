require 'test_helper'

class Kind::ResultFailureTest < Minitest::Test
  require 'kind/result'

  def test_the_result_failure
    result = Kind::Failure(1)

    assert_equal(1, result.value)

    assert_equal('#<Kind::Failure type=:error value=1>', result.inspect)

    assert result.failed?
    assert result.failure?
    refute result.success?
    refute result.succeeded?

    assert :error == result.type

    assert_equal(1, result.map { |n| n + 2 }.value)
    assert_equal(1, result.map { |n| Kind::Right(n + 2) }.value)

    assert_equal(1, result.then { |n| n + 2 }.value)
    assert_equal(1, result.then { |n| Kind::Right(n + 2) }.value)

    assert_equal(2, result.value_or(2))
    assert_equal(3, result.value_or { 3 })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { result.value_or }

    assert_same(result, result.on_failure {})
    assert_same(result, result.on_success { raise RuntimeError })
  end

  def test_the_failure_builder
    result1 = Kind::Failure(:invalid)

    assert result1.failure?

    assert :error == result1.type
    assert :invalid == result1.value

    # --

    result2 = Kind::Failure(:invalid, false)

    assert result2.failure?

    assert :invalid == result2.type
    assert false == result2.value

    # --

    assert_raises_with_message(
      Kind::Error,
      '"invalid" expected to be a kind of Symbol'
    ) { Kind::Failure('invalid', true) }

    # --

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 0, expected 1 or 2)'
    ) { Kind::Failure() }
  end

  def test_the_failure_hook
    result = Kind::Failure(1)

    count = 0

    result
      .on_failure { |n| count += n }
      .on_success { raise }
      .on_failure(:error) { |n| count += n }
      .on_failure([:invalid, :error]) { |n| count += n }
      .on_failure(Float) { raise }
      .on_failure(String) { raise }
      .on_failure(Numeric) { |n| count += n }
      .on_failure([:invalid, :error], Float) { raise }
      .on_failure([:invalid, :error], Numeric) { |n| count += n }

    assert_equal(5, count)

    # --

    assert_nil(result.on {})
    assert_nil(result.on { |_| _.success {} })

    assert_equal(0, result.on do |_|
      _.failure { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_equal(0, result.on do |_|
      _.failure(:error) { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_equal(0, result.on do |_|
      _.success([:invalid, :error]) { |value| value - 2 }
      _.failure([:invalid, :error]) { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_equal(0, result.on do |_|
      _.failure(String) { |value| value - 2 }
      _.success(Numeric) { |value| value - 3 }
      _.failure(Numeric) { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_equal(0, result.on do |_|
      _.failure([:invalid, :error], String) { |value| value - 1 }
      _.failure([:invalid, :error], Numeric) { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_equal(-1, result.on do |_|
      _.failure { |value| value - 2 }
      _.failure(:invalid, :error) { |value| value - 1 }
      _.success { |value| value + 1 }
    end)

    assert_nil(result.on do |_|
      _.failure(:foo) { |value| value - 1 }
      _.failure(:bar) { |value| value - 1 }
    end)
  end

  def test_the_case_equality
    success = Kind::Failure(:invalid, 0)

    count = 0

    case success
    when Kind::Failure(Numeric)           then count -= 1
    when Kind::Failure(:invalid, 2)       then count -= 1
    when Kind::Failure(:invalid, Numeric) then count += 1
    end

    case success
    when Kind::Failure(Numeric)     then count -= 1
    when Kind::Failure(:invalid, 0) then count += 1
    end

    assert_equal(2, count)
  end
end
