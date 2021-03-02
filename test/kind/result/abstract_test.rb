require 'test_helper'

class KindResultAbstractTest < Minitest::Test
  require 'kind/result'

  class AbstractResult
    include Kind::Result::Abstract
  end

  def test_the_resultable_contract
    result = AbstractResult.new

    assert_raises(NotImplementedError) { result.on }
    assert_raises(NotImplementedError) { result.on {} }
    assert_raises(NotImplementedError) { result.on_success { 0 } }
    assert_raises(NotImplementedError) { result.on_failure { 1 } }
  end
end
