require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindValidatorKindOfTest < Minitest::Test
    class Person
      include ActiveModel::Validations

      attr_reader :name, :age, :alive

      validates :name, kind: { of: String }
      validates :age, kind: { of: Integer }
      validates :alive, kind: { of: Kind::Boolean }

      def initialize(name:, age:, alive:)
        @name, @age, @alive = name, age, alive
      end
    end

    def test_the_validation_with_a_single_type
      invalid_person = Person.new(name: 21, age: 'John', alive: 0)

      refute_predicate(invalid_person, :valid?)
      assert_equal(['must be a kind of String'], invalid_person.errors[:name])
      assert_equal(['must be a kind of Integer'], invalid_person.errors[:age])
      assert_equal(['must be a kind of Boolean'], invalid_person.errors[:alive])

      person = Person.new(name: 'John', age: 21, alive: false)

      assert_predicate(person, :valid?)
    end

    class MyString < String; end

    def test_that_will_be_valid_when_checks_a_subclass
      person = Person.new(name: MyString.new('John'), age: 21, alive: true)

      assert_predicate(person, :valid?)
    end

    # ---

    class Job
      include ActiveModel::Validations

      attr_reader :id, :status

      validates :id, kind: { of: Integer }, allow_nil: true
      validates :status, kind: { of: [String, Symbol] }

      def initialize(status:, id: nil)
        @status, @id = status, id
      end
    end

    def test_the_validation_with_multiple_types
      job1 = Job.new(id: 1, status: 'sleeping')
      job2 = Job.new(id: 2, status: :sleeping)
      job3 = Job.new(id: 3, status: 0)

      assert_predicate(job1, :valid?)
      assert_predicate(job2, :valid?)

      refute_predicate(job3, :valid?)
      assert_equal(['must be a kind of String, Symbol'], job3.errors[:status])
    end

    def test_the_allow_nil_validation_options
      job1 = Job.new(status: 'sleeping')
      job2 = Job.new(id: '3', status: 'sleeping')

      assert_predicate(job1, :valid?)

      refute_predicate(job2, :valid?)
      assert_equal(['must be a kind of Integer'], job2.errors[:id])
    end

    # ---

    class Task
      include ActiveModel::Validations

      attr_reader :title

      validates! :title, kind: { of: String }, allow_nil: true

      def initialize(title:)
        @title = title
      end
    end

    def test_strict_validations
      assert_predicate(Task.new(title: nil), :valid?)
      assert_predicate(Task.new(title: 'Buy milk'), :valid?)

      assert_raises_kind_error('title must be a kind of String') do
        Task.new(title: 42).valid?
      end
    end

    class User
      include ActiveModel::Validations

      attr_reader :name, :bool

      FilledString = ->(value) { value.kind_of?(String) && !value.empty? }

      Bool = Object.new
      def Bool.===(value)
        value == true || value == false
      end
      def Bool.name; 'Bool'; end

      validates :name, kind: FilledString
      validates :bool, kind: Bool

      def initialize(name:, bool:)
      @name, @bool = name, bool
      end
    end

    def test_the_usage_of_lambdas_to_perform_validations
      invalid_user = User.new(name: '', bool: 1)

      refute_predicate(invalid_user, :valid?)
      assert_equal(['invalid kind'], invalid_user.errors[:name])
      assert_equal(['must be a kind of Bool'], invalid_user.errors[:bool])

      assert User.new(name: 'Serradura', bool: true).valid?
    end
  end
end
