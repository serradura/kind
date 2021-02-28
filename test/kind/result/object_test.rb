require 'test_helper'

class Kind::ResultObjectTest < Minitest::Test
  require 'kind/result'

  def test_the_result_object
    object = Object.new

    result = Kind::Result::Object.new(:type, object)

    assert_same(object, result.value)
    assert_equal(:type, result.type)

    refute result.failed?
    refute result.failure?
    refute result.success?
    refute result.succeeded?

    assert_same(result, result.on_failure {})
    assert_same(result, result.on_success {})

    assert_raises(NotImplementedError) { result.map { 0 } }
    assert_raises(NotImplementedError) { result.then { 0 } }
    assert_raises(NotImplementedError) { result.value_or(2) }
    assert_raises(NotImplementedError) { result.value_or { 3 } }

    assert_nil(result.on {})
    assert_nil(result.on { |_| _.failure {} })
    assert_nil(result.on { |_| _.success {} })

    type, value = result

    assert_equal([:type, object], [type, value])
  end
end
