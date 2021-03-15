require 'test_helper'

class Kind::ResultMonadTest < Minitest::Test
  require 'kind/result'

  def test_the_result_monad
    object = Object.new

    result = Kind::Result::Monad[:type, object]

    assert_same(object, result.value)
    assert_equal(:type, result.type)

    refute result.failed?
    refute result.failure?
    refute result.success?
    refute result.succeeded?

    assert_same(result, result.on_failure {})
    assert_same(result, result.on_success {})

    assert_raises(NotImplementedError) { result.map { 0 } }
    assert_raises(NotImplementedError) { result.map! { 0 } }
    assert_raises(NotImplementedError) { result.then { 0 } }
    assert_raises(NotImplementedError) { result.then! { 0 } }
    assert_raises(NotImplementedError) { result.and_then { 0 } }
    assert_raises(NotImplementedError) { result.and_then! { 0 } }
    assert_raises(NotImplementedError) { result.value_or(2) }
    assert_raises(NotImplementedError) { result.value_or { 3 } }

    assert_nil(result.on {})
    assert_nil(result.on { |_| _.failure {} })
    assert_nil(result.on { |_| _.success {} })

    type, value = result

    assert_equal([:type, object], [type, value])
  end

  def test_the_from_method
    success1 = Kind::Result.from { 1 }
    success2 = Kind::Result.from { Kind::Success(3) }

    failure1 = Kind::Result.from { 2 / 0 }
    failure2 = Kind::Result.from { Kind::Failure(4) }

    assert success1.success?
    assert success1.value == 1

    assert success2.success?
    assert success2.value == 3

    assert failure1.failure?
    assert_equal(:exception, failure1.type)
    assert_instance_of(ZeroDivisionError, failure1.value)

    assert failure2.failure?
    assert failure2.value == 4
  end

  def test_the_map_methods_aliases
    success = Kind::Success(1)

    assert success.method(:map) == success.method(:then)
    assert success.method(:map) == success.method(:and_then)
    assert success.method(:map!) == success.method(:then!)
    assert success.method(:map!) == success.method(:and_then!)

    failure = Kind::Failure(0)

    assert failure.method(:map) == failure.method(:then)
    assert failure.method(:map) == failure.method(:and_then)
    assert failure.method(:map!) == failure.method(:then!)
    assert failure.method(:map!) == failure.method(:and_then!)
  end
end
