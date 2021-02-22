require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationRespondToTest < Minitest::Test
    class Person
      include ActiveModel::Validations

      attr_reader :handler

      validates :handler, kind: { respond_to: :call }, allow_nil: true

      def initialize(handler:)
        @handler = handler
      end
    end

    def test_the_respond_to_validation
      invalid_person = Person.new(handler: 21)

      refute_predicate(invalid_person, :valid?)

      assert_equal(['must respond to the method: `call`'], invalid_person.errors[:handler])

      person = Person.new(handler: -> {})

      assert_predicate(person, :valid?)
    end

    def test_the_allow_nil_validation_options
      person = Person.new(handler: nil)

      assert_predicate(person, :valid?)
    end

    # ---

    class Task
      include ActiveModel::Validations

      attr_reader :handler

      validates! :handler, kind: { respond_to: [:call, :lambda?] }, allow_nil: true

      def initialize(handler:)
        @handler = handler
      end
    end

    def test_strict_validations
      assert_predicate(Task.new(handler: nil), :valid?)
      assert_predicate(Task.new(handler: -> {}), :valid?)

      assert_raises_kind_error('handler must respond to the methods: `call`, `lambda?`') do
        Task.new(handler: 42).valid?
      end
    end
  end
end
