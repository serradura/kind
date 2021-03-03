require 'test_helper'

class KindFunctionTest < Minitest::Test
  require 'kind/function'

  module Add
    extend Kind::Function

    def call(a, b)
      number(a) + number(b)
    end

    private

      def number(value)
        value.kind_of?(Numeric) ? value : 0
      end

    require_function_contract!
  end

  def test_that_a_module_behave_like_a_lambda
    assert 2 == Add.(1, 1)
    assert 4 == Add.call(2, 2)
    assert 6 == Add[3, 3]
    assert 8 == Add.===(4, 4)
    assert 10 == Add.yield(5, 5)
  end

  def test_the_curry_method
    add3 = Add.curry[3]

    assert 4 == add3[1]
  end

  module Double
    extend Kind::Function

    def call(n)
      n * 2
    end

    require_function_contract!
  end

  module Triple
    extend Kind::Function

    def call(number:)
      number * 3
    end

    require_function_contract!
  end

  module Sum
    extend Kind::Function

    def call(*args)
      args.map! { |value| value.kind_of?(Numeric) ? value : 0 }
      args.reduce(:+)
    end

    require_function_contract!
  end

  def test_that_module_to_proc
    assert [2, 4, 6] == [1, 2, 3].map(&Double)

    assert 6 == Triple.to_proc[number: 2]

    assert 6 == Sum.to_proc[1, 2, 3]
  end

  @@contract_error1 =
    begin
      module Foo
        extend Kind::Function

        require_function_contract!
      end
    rescue => e
      e
    end

  @@contract_error2 =
    begin
      module Bar
        extend Kind::Function

        def call; end

        require_function_contract!
      end
    rescue => e
      e
    end

  def test_the_contract_errors
    assert Kind::Error === @@contract_error1
    assert_equal('expected KindFunctionTest::Foo to respond to :call', @@contract_error1.message)

    assert ArgumentError === @@contract_error2
    assert_equal('KindFunctionTest::Bar.call must receive at least one argument', @@contract_error2.message)
  end

  @@wrong_usage_error1 =
    begin
      class Biz
        include Kind::Function
      end
    rescue => e
      e
    end

  @@wrong_usage_error2 =
    begin
      class Baz
        extend Kind::Function
      end
    rescue => e
      e
    end

  def test_the_wrong_usage_errors
    assert RuntimeError === @@wrong_usage_error1
    assert_equal("The Kind::Function can't be included, it can be only extended.", @@wrong_usage_error1.message)

    assert Kind::Error === @@wrong_usage_error2
    assert_equal('KindFunctionTest::Baz expected to be a kind of Module', @@wrong_usage_error2.message)
  end

  def test_the_execution_of_require_function_contract_twice
    assert Add == Add.require_function_contract!
  end
end
