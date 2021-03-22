require 'test_helper'

class Kind::TransactionTest < Minitest::Test
  include StepAdapterAssertions

  require 'kind/empty'
  require 'kind/result'

  module Kind::Transaction
    module StepAdapters
      private

        def Step(method_name)
          ->(value) { send(method_name, value) }
        end

        def Map(method_name)
          ->(value) { Success(method_name, send(method_name, value)) }
        end

        def Check(method_name)
          ->(value) do
            send(method_name, value) ? Success(method_name, value) : Failure(method_name, value)
          end
        end

        def Try(method_name, opt = Empty::HASH)
          ->(value) do
            begin
              Success(method_name, send(method_name, value))
            rescue opt.fetch(:catch, StandardError) => e
              Failure(method_name, e)
            end
          end
        end

        def Tee(method_name)
          ->(value) do
            send(method_name, value)

            Success(method_name, value)
          end
        end
    end

    def self.extended(base)
      base.extend(Kind.of_module(base))
      base.send(:extend, Kind::Result::Methods)
      base.send(:extend, StepAdapters)
    end

    def self.included(base)
      Kind.of_class(base).send(:include, Kind::Result::Methods)
      base.send(:include, StepAdapters)
    end

    private_constant :StepAdapters
  end

  DB = []

  module CreateUser1
    extend Kind::Transaction

    def call(input)
      validate(input) \
        | Step(:create) \
        | Step(:welcome_email)
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
  end

  def test_the_create_user_module
    assert_create_user(CreateUser1, DB)
  end

  class CreateUser2
    include Kind::Transaction

    def call(input)
      validate(input) \
        | Step(:create) \
        | Step(:welcome_email)
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
  end

  def test_the_create_user_instance
    assert_create_user(CreateUser2.new, DB)
  end

  module Add
    extend Kind::Transaction

    def call(input)
      Success(input) \
        | Check(:presence) \
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
  end

  def test_the_addition
    assert_addition(Add)
  end

  module Divide
    extend Kind::Transaction

    def call(input)
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
  end

  def test_the_division
    assert_division(Divide)
  end

  LOG = []

  module Multiply
    extend Kind::Transaction

    def call(input)
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
  end

  def test_the_multiplication
    assert_multiplication(Multiply, LOG)
  end

  module Double
    extend Kind::Transaction

    def call(number)
      Success(number * 2)
    end
  end

  def test_add_and_double
    assert_add_and_double(Add, Double)
  end
end
