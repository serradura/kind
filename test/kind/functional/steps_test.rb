require 'test_helper'

class KindFunctionalStepsTest < Minitest::Test
  require 'kind/functional/steps'

  class BaseJob
    def self.perform_now(input)
      new.perform(input)
    end

    def perform(input)
      raise NotImplementedError
    end
  end

  DB = []

  class CreateUserJob < BaseJob
    include Kind::Functional::Steps

    def perform(input)
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
  end

  def test_create_user_job
    DB.clear

    # --

    result1 = CreateUserJob.perform_now(name: nil, email: nil)

    assert result1.failure?
    assert_equal(:error, result1.type)
    assert_equal('ops... Name and email must be present!', result1.value)

    # --

    result2 = CreateUserJob.perform_now(name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com')

    assert result2.success?
    assert_equal(:ok, result2.type)
    assert_equal('Please, confirm your email.', result2.value)

    assert_equal(
      {name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com'},
      DB.last
    )
  end

  module CreateUser
    extend self, Kind::Functional::Steps

    def perform(input)
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
  end

  def test_create_user
    DB.clear

    # --

    result1 = CreateUser.perform(name: nil, email: nil)

    assert result1.failure?
    assert_equal(:error, result1.type)
    assert_equal('ops... Name and email must be present!', result1.value)

    # --

    result2 = CreateUser.perform(name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com')

    assert result2.success?
    assert_equal(:ok, result2.type)
    assert_equal('Please, confirm your email.', result2.value)

    assert_equal(
      {name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com'},
      DB.last
    )
  end
end
