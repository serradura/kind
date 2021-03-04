require 'test_helper'

class Kind::ResultMethodsTest < Minitest::Test
  require 'kind/result'

  class Sum
    include Kind::Result::Methods

    def initialize(a, b)
      @a, @b = a, b
    end

    def call
      return Success(@a + @b) if Kind::Numeric?(@a, @b)

      Failure('a anb b must be numerics')
    end
  end

  def test_the_Failure_and_Success_methods
    result1 = Sum.new(1, 1).call

    assert result1.success?
    assert result1.value == 2

    # --

    result2 = Sum.new(1, '1').call

    assert result2.failure?
    assert result2.value == 'a anb b must be numerics'
  end
end
