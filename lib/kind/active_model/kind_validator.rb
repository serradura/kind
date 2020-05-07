# frozen_string_literal: true

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
      types = Array(expected)

      return if types.any? { |type| value.kind_of?(type) }

      "must be a kind of: #{types.map { |klass| klass.name }.join(', ')}"
    end

    CLASS_OR_MODULE = 'Class/Module'.freeze

    def kind_is(expected, value)
      return kind_is_not(expected, value) unless expected.kind_of?(Array)

      result = expected.map { |kind| kind_is_not(kind, value) }.compact

      result.empty? || result.size < expected.size ? nil : result.join(', ')
    end

    def kind_is_not(expected, value)
      case expected
      when Class
        return if Kind.of.Class(value) == expected || value < expected

        "must be the class or a subclass of `#{expected.name}`"
      when Module
        return if value.kind_of?(Class) && value <= expected
        return if Kind.of.Module(value) == expected || value.kind_of?(expected)

        "must include the `#{expected.name}` module"
      else
        raise Kind::Error.new(CLASS_OR_MODULE, expected)
      end
    end

    def respond_to(method_name, value)
      return if value.respond_to?(method_name)

      "must respond to the method `#{method_name}`"
    end

    def instance_of(expected, value)
      types = Array(expected)

      return if types.any? { |type| value.instance_of?(type) }

      "must be an instance of: #{types.map { |klass| klass.name }.join(', ')}"
    end

    def array_with(expected, value)
      return if value.kind_of?(Array) && !value.empty? && (value - Kind.of.Array(expected)).empty?

      "must be an array with: #{expected.join(', ')}"
    end

    def array_of(expected, value)
      types = Array(expected)

      return if value.kind_of?(Array) && !value.empty? && value.all? { |value| types.any? { |type| value.kind_of?(type) } }

      "must be an array of: #{types.map { |klass| klass.name }.join(', ')}"
    end
end
