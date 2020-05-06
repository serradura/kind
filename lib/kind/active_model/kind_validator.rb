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

      return kind_of(expected, value) if expected = options[:of] || options[:is_a]
      return is_class(expected, value) if expected = options[:is] || options[:klass]
      return respond_to(expected, value) if expected = options[:respond_to]
      return instance_of(expected, value) if expected = options[:instance_of]
      return array_with(expected, value) if expected = options[:array_with]
      return array_of(expected, value) if expected = options[:array_of]

      raise Kind::Validator::InvalidDefinition.new(attribute)
    end

    def validate_with_default_strategy(expected, value)
      send(Kind::Validator.default_strategy, expected, value)
    end

    def instance_of(expected, value)
      types = Array(expected)

      return if types.any? { |type| value.instance_of?(type) }

      "must be an instance of: #{types.map { |klass| klass.name }.join(', ')}"
    end

    def kind_of(expected, value)
      types = Array(expected)

      return if types.any? { |type| value.is_a?(type) }

      "must be a kind of: #{types.map { |klass| klass.name }.join(', ')}"
    end

    def is_class(klass, value)
      return if Kind.of.Class(value) == Kind.of.Class(klass) || value < klass

      "must be the class or a subclass of `#{klass.name}`"
    end

    def respond_to(method_name, value)
      return if value.respond_to?(method_name)

      "must respond to the method `#{method_name}`"
    end

    def array_of(expected, value)
      types = Array(expected)

      return if value.is_a?(Array) && !value.empty? && value.all? { |value| types.any? { |type| value.is_a?(type) } }

      "must be an array of: #{types.map { |klass| klass.name }.join(', ')}"
    end

    def array_with(expected, value)
      return if value.is_a?(Array) && !value.empty? && (value - Kind.of.Array(expected)).empty?

      "must be an array with: #{expected.join(', ')}"
    end
end
