require 'test_helper'

if ENV['ACTIVEMODEL_VERSION']
  class KindActiveModelValidationErrorsTest < Minitest::Test
    class InvalidValidation
      include ActiveModel::Validations

      attr_reader :name

      validates :name, kind: {}
    end

    class InvalidValidationWithNil
      include ActiveModel::Validations

      attr_reader :name

      validates :name, kind: { name: nil }
    end

    class InvalidValidationWithAnEmptyArray
      include ActiveModel::Validations

      attr_reader :name

      validates :name, kind: { name: [] }
    end

    def test_the_exception_raised_because_of_the_wrong_definition
      expected_message = [
        'invalid type definition for :name attribute.',
        'Options to define one: :of, :instance_of, :respond_to, :klass, :array_of or :array_with'
      ].join(' ')

      [
        InvalidValidation.new,
        InvalidValidationWithNil.new,
        InvalidValidationWithAnEmptyArray.new
      ].each do |instance|
        assert_raises_with_message(Kind::Validator::InvalidDefinition, expected_message) do
          instance.valid?
        end
      end
    end

    def test_the_exception_raised_because_of_a_wrong_default
      expected_message = [
        'invalid type definition for :name attribute.',
        'Options to define one: :of, :instance_of, :respond_to, :klass, :array_of or :array_with'
      ].join(' ')

      [
        InvalidValidation.new,
        InvalidValidationWithNil.new,
        InvalidValidationWithAnEmptyArray.new
      ].each do |instance|
        assert_raises_with_message(Kind::Validator::InvalidDefinition, expected_message) do
          instance.valid?
        end
      end
    end
  end
end
