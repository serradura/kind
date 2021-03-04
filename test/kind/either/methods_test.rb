require 'test_helper'

class Kind::EitherMethodsTest < Minitest::Test
  require 'kind/either'

  class Sum
    include Kind::Either::Methods

    def initialize(a, b)
      @a, @b = a, b
    end

    def call
      return Right(@a + @b) if Kind.of?(Numeric, @a, @b)

      Left('a anb b must be numerics')
    end
  end

  def test_the_Left_and_Right_methods
    result1 = Sum.new(1, 1).call

    assert result1.right?
    assert result1.value == 2

    # --

    result2 = Sum.new(1, '1').call

    assert result2.left?
    assert result2.value == 'a anb b must be numerics'
  end
end
