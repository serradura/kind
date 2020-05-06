require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationArrayWithTest < Minitest::Test
    class Person
      include ActiveModel::Validations

      attr_reader :values

      validates :values, kind: { array_with: [1, 2, 3] }, allow_nil: true

      def initialize(values:)
        @values = values
      end
    end

    def test_the_array_with_validation
      [
        Person.new(values: [4]),
        Person.new(values: 1),
        Person.new(values: [1, 2, 3, 5])
      ].each do |person|
        refute_predicate(person, :valid?)
        assert_equal(['must be an array with: 1, 2, 3'], person.errors[:values])
      end

      person = Person.new(values: [1])

      assert_predicate(person, :valid?)
    end

    def test_the_allow_nil_validation_options
      person = Person.new(values: nil)

      assert_predicate(person, :valid?)
    end

    # ---

    class Task
      include ActiveModel::Validations

      attr_reader :values

      validates! :values, kind: { array_with: [1, 2, 3] }, allow_nil: true

      def initialize(values:)
        @values = values
      end
    end

    def test_strict_validations
      [
        Task.new(values: nil),
        Task.new(values: [2, 3])
      ].each do |task|
        assert_predicate(task, :valid?)
      end

      [
        Task.new(values: 1),
        Task.new(values: []),
        Task.new(values: [4])
      ].each do |task|
        assert_raises_kind_error('values must be an array with: 1, 2, 3') do
          task.valid?
        end
      end
    end

    # ---

    class Foo
      include ActiveModel::Validations

      attr_reader :values

      validates! :values, kind: { array_with: 42 }, allow_nil: true

      def initialize(values:)
        @values = values
      end
    end

    def test_the_validation_argument_error
      assert_raises_kind_error('42 expected to be a kind of Array') do
        Foo.new(values: [1]).valid?
      end
    end
  end
end
