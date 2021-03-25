require 'test_helper'

class KindFunctionalActionStepAdaptersClassesTest < Minitest::Test
  include StepAdapterAssertions

  require 'kind/functional/action'

  DB = []

  class CreateUser
    include Kind::Functional::Action

    def call!(input)
      validate(input) \
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
    assert_create_user(CreateUser.new, DB)
  end

  class Add
    include Kind::Functional::Action

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
    assert_addition(Add.new)
  end

  class Divide
    include Kind::Functional::Action

    def call!(input)
      normalize(input) \
        | Try(:calc, catch: ZeroDivisionError)
    end

    private

      def normalize(input)
        Success([input[:a], input[:b]])
      end

      def calc((a, b))
        a / b
      end

    kind_functional_action!
  end

  def test_the_division
    assert_division(Divide.new)
  end

  LOG = []

  class Multiply
    include Kind::Functional::Action

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

  def test_the_multiplication
    assert_multiplication(Multiply.new, LOG)
  end

  class Double
    include Kind::Functional::Action

    def call!(number)
      Success(number * 2)
    end

    kind_functional_action!
  end

  def test_add_and_double
    assert_add_and_double(Add.new, Double.new)
  end
end
