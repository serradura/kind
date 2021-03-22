# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Validator
    DEFAULT_STRATEGIES = ::Set.new(%w[instance_of kind_of]).freeze

    class InvalidDefinition < ArgumentError
      OPTIONS = 'Options to define one: :of, :is, :respond_to, :instance_of, :array_of or :array_with'.freeze

      def initialize(attribute)
        super "invalid type definition for :#{attribute} attribute. #{OPTIONS}"
      end

      private_constant :OPTIONS
    end

    class InvalidDefaultStrategy < ArgumentError
      OPTIONS =
        DEFAULT_STRATEGIES.map { |option| ":#{option}" }.join(', ')

      def initialize(option)
        super "#{option.inspect} is an invalid option. Please use one of these: #{OPTIONS}"
      end

      private_constant :OPTIONS
    end

    def self.default_strategy
      @default_strategy ||= :kind_of
    end

    def self.default_strategy=(option)
      if DEFAULT_STRATEGIES.member?(String(option))
        @default_strategy = option.to_sym
      else
        raise InvalidDefaultStrategy.new(option)
      end
    end
  end
end

require 'active_model'
require 'active_model/validations'

class KindValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:allow_nil] && value.nil?

    return unless error = call_validation_for(attribute, value)

    raise Kind::Error.new("#{attribute} #{error}") if options[:strict]

    record.errors.add(attribute, error)
  end

  private

    def call_validation_for(attribute, value)
      expected = options[:with] || options[:in]

      return validate_with_default_strategy(expected, value) if expected

      return kind_of(expected, value) if expected = options[:of]
      return kind_is(expected, value) if expected = options[:is]
      return respond_to(expected, value) if expected = options[:respond_to]
      return instance_of(expected, value) if expected = options[:instance_of]
      return array_with(expected, value) if expected = options[:array_with]
      return array_of(expected, value) if expected = options[:array_of]

      raise Kind::Validator::InvalidDefinition.new(attribute)
    end

    def validate_with_default_strategy(expected, value)
      send(Kind::Validator.default_strategy, expected, value)
    end

    def kind_of(expected, value)
      if ::Array === expected
        return if expected.any? { |type| type === value }

        "must be a kind of #{expected.map { |type| type.name }.join(', ')}"
      else
        return if expected === value

        expected.respond_to?(:name) ? "must be a kind of #{expected.name}" : 'invalid kind'
      end
    end

    CLASS_OR_MODULE = 'Class/Module'.freeze

    def kind_is(expected, value)
      return kind_is_not(expected, value) unless expected.kind_of?(::Array)

      result = expected.map { |kind| kind_is_not(kind, value) }.tap(&:compact!)

      result.empty? || result.size < expected.size ? nil : result.join(', ')
    end

    def kind_is_not(expected, value)
      case expected
      when ::Class
        return if expected == Kind.of_class(value) || value < expected

        "must be the class or a subclass of `#{expected.name}`"
      when ::Module
        return if value.kind_of?(::Class) && value <= expected
        return if expected == Kind.of_module_or_class(value) || value.kind_of?(expected)

        "must include the `#{expected.name}` module"
      else
        raise Kind::Error.new(CLASS_OR_MODULE, expected)
      end
    end

    def respond_to(expected, value)
      method_names = Array(expected)

      expected_methods = method_names.select { |method_name| !value.respond_to?(method_name) }
      expected_methods.map! { |method_name| "`#{method_name}`" }

      return if expected_methods.empty?

      methods = expected_methods.size == 1 ? 'method' : 'methods'

      "must respond to the #{methods}: #{expected_methods.join(', ')}"
    end

    def instance_of(expected, value)
      types = Array(expected)

      return if types.any? { |type| value.instance_of?(type) }

      "must be an instance of #{types.map { |klass| klass.name }.join(', ')}"
    end

    def array_with(expected, value)
      return if value.kind_of?(::Array) && !value.empty? && (value - Kind.of!(::Array, expected)).empty?

      "must be an array with #{expected.join(', ')}"
    end

    def array_of(expected, value)
      types = Array(expected)

      return if value.kind_of?(::Array) && !value.empty? && value.all? { |val| types.any? { |type| type === val } }

      "must be an array of #{types.map { |klass| klass.name }.join(', ')}"
    end
end
