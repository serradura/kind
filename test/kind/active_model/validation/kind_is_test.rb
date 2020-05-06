require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationKindIsTest < Minitest::Test
    BaseHandler = Class.new
    TaskHandler = Class.new(BaseHandler)

    class Person
      include ActiveModel::Validations

      attr_reader :handler

      validates :handler, kind: { is: BaseHandler }, allow_nil: true

      def initialize(handler:)
        @handler = handler
      end
    end

    def test_the_klass_validation
      invalid_person = Person.new(handler: Hash)

      refute_predicate(invalid_person, :valid?)
      assert_equal(
        ['must be the class or a subclass of `KindActiveModelValidationKindIsTest::BaseHandler`'],
        invalid_person.errors[:handler]
      )

      person = Person.new(handler: BaseHandler)

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

      validates! :handler, kind: { is: BaseHandler }, allow_nil: true

      def initialize(handler:)
        @handler = handler
      end
    end

    def test_strict_validations
      assert_predicate(Task.new(handler: nil), :valid?)
      assert_predicate(Task.new(handler: BaseHandler), :valid?)
      assert_predicate(Task.new(handler: TaskHandler), :valid?)

      assert_raises_kind_error(
        'handler must be the class or a subclass of `KindActiveModelValidationKindIsTest::BaseHandler`'
      ) { Task.new(handler: Array).valid? }
    end

    # ---

    class Foo
      include ActiveModel::Validations

      attr_reader :handler

      validates! :handler, kind: { is: 42 }, allow_nil: true

      def initialize(handler:)
        @handler = handler
      end
    end

    def test_the_validation_argument_error
      assert_raises_kind_error("42 expected to be a kind of Class") do
        Foo.new(handler: Array).valid?
      end

      assert_raises_kind_error("[] expected to be a kind of Class") do
        Foo.new(handler: []).valid?
      end
    end
  end
end
