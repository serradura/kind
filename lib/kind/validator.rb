# frozen_string_literal: true

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
