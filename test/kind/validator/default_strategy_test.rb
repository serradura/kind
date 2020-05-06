require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationDefaultStrategyTest < Minitest::Test
    class MyString < String; end

    class Person
      include ActiveModel::Validations

      attr_reader :name

      validates :name, kind: String

      def initialize(name:)
        @name = name
      end
    end

    def test_the_default_strategy
      invalid_person = Person.new(name: 21)

      refute_predicate(invalid_person, :valid?)
      assert_equal(['must be a kind of: String'], invalid_person.errors[:name])

      person = Person.new(name: MyString.new('John'))

      assert_predicate(person, :valid?)
    end

    def test_a_new_default_strategy
      default_strategy = Kind::Validator.default_strategy

      Kind::Validator.default_strategy = 'instance_of'

      [
        Person.new(name: 21),
        Person.new(name: MyString.new('John'))
      ].each do |person|
        refute_predicate(person, :valid?)
        assert_equal(['must be an instance of: String'], person.errors[:name])
      end

      Kind::Validator.default_strategy = :kind_of

      [
        Person.new(name: MyString.new('John'))
      ].each { |person| assert_predicate(person, :valid?) }

      Kind::Validator.default_strategy = default_strategy
    end

    # ---

    class User
      include ActiveModel::Validations

      attr_reader :name

      validates :name, kind: [String, Symbol], allow_nil: true

      def initialize(name:)
        @name = name
      end
    end

    def test_the_default_strategy_with_multiple_classes
      invalid_user = User.new(name: 21)

      refute_predicate(invalid_user, :valid?)
      assert_equal(['must be a kind of: String, Symbol'], invalid_user.errors[:name])

      [
        User.new(name: :John),
        User.new(name: 'John'),
        User.new(name: nil)
      ].each { |user| assert_predicate(user, :valid?) }
    end

    def test_the_invalid_default_strategy_error
      assert_raises_with_message(
        Kind::Validator::InvalidDefaultStrategy,
        ':bar is an invalid option. Please use one of these: :instance_of, :kind_of, :is_a'
      ) { Kind::Validator.default_strategy = :bar }
    end
  end
end
