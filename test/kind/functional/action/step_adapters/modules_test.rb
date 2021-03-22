require 'test_helper'

class KindFunctionalActionStepAdaptersModulesTest < Minitest::Test
  include StepAdapterAssertions

  require 'kind/functional/action'

  DB = []

  module CreateUser
    extend Kind::Functional::Action

    def call!(input)
      Step!(:validate, input) \
        >> Step(:create) \
        >> Step(:welcome_email)
    end

    private

      def validate(input)
        return Success(input) if input[:name] && input[:email]

        Failure('ops... Name and email must be present!')
      end

      def create(input)
        return Success(input[:email]) if DB.push(input)

        Failure('Panic!!!')
      end

      def welcome_email(email)
        # UserMailer.welcome(email).deliver_later

        Success('Please, confirm your email.')
      end

    kind_functional_action!
  end

  def test_the_create_user
    assert_create_user(CreateUser, DB)
  end

  module Add
    extend Kind::Functional::Action

    def call!(input)
      Check!(:presence, input) \
        | Map(:normalize) \
        | Map(:calc)
    end

    private

      def presence(input)
        input.is_a?(Hash) && input[:a] && input[:b]
      end

      def normalize(input)
        [input[:a].to_i, input[:b].to_i]
      end

      def calc((a, b))
        a + b
      end

    kind_functional_action!
  end

  def test_the_addition
    assert_addition(Add)
  end

  module Divide
    extend Kind::Functional::Action

    def call!(input)
      Map!(:normalize, input) \
        | Try(:calc, catch: ZeroDivisionError)
    end

    private

      def normalize(input)
        [input[:a], input[:b]]
      end

      def calc((a, b))
        a / b
      end

    kind_functional_action!
  end

  module Divide2
    extend Kind::Functional::Action

    def call!(input)
      Try!(:calc, input, catch: ZeroDivisionError)
    end

    private

      def calc(input)
        input[:a] / input[:b]
      end

    kind_functional_action!
  end

  def test_the_division
    assert_division(Divide)

    # --

    result1 = Divide2.(a: 2, b: 2)
    assert result1.success?
    assert_equal(1, result1.value)

    # --

    result2 = Divide2.(a: 2, b: 0)
    assert result2.failure?
    assert_instance_of(ZeroDivisionError, result2.value)
  end

  LOG = []

  module Multiply
    extend Kind::Functional::Action

    def call!(input)
      normalize(input) \
        | Tee(:log)  \
        | Map(:calc)
    end

    private

      def normalize(input)
        Success([input[:a], input[:b]])
      end

      def log(input)
        LOG << input.inspect
      end

      def calc((a, b))
        a * b
      end

    kind_functional_action!
  end

  module Multiply2
    extend Kind::Functional::Action

    def call!(input)
      Tee!(:log, input)  \
        | Map(:calc)
    end

    private

      def log(input)
        item = [input[:a], input[:b]]

        LOG << item.inspect
      end

      def calc(input)
        input[:a] * input[:b]
      end

    kind_functional_action!
  end

  def test_the_multiplication
    assert_multiplication(Multiply, LOG)

    # --

    result = Multiply2.(a: 3, b: 3)
    assert result.success?
    assert_equal(9, result.value)
    assert_equal('[3, 3]', LOG.last)
  end

  module Double
    extend Kind::Functional::Action

    def call!(number)
      Success(number * 2)
    end

    kind_functional_action!
  end

  def test_add_and_double
    assert_add_and_double(Add, Double)
  end
end
