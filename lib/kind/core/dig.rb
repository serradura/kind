# frozen_string_literal: true

module Kind
  module Dig
    extend self

    def call(data, keys)
      return unless keys.kind_of?(::Array)

      keys.reduce(data) do |memo, key|
        value = get(memo, key)

        break if KIND.null?(value)

        value
      end
    end

    def [](*keys)
      ->(data) { call(data, keys) }
    end

    private

      def get(data, key)
        return data[key] if ::Hash === data

        case data
        when ::Array
          data[key] if key.respond_to?(:to_int)
        when ::OpenStruct
          data[key] if key.respond_to?(:to_sym)
        when ::Struct
          data[key] rescue nil if key.respond_to?(:to_int) || key.respond_to?(:to_sym)
        else
          data.public_send(key) if key.respond_to?(:to_sym) && data.respond_to?(key)
        end
      end
  end
end
