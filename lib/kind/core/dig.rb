# frozen_string_literal: true

module Kind
  module Dig
    extend self

    def call!(data, keys = Empty::ARRAY) # :nodoc
      keys.reduce(data) do |memo, key|
        value = get(memo, key)

        break if KIND.null?(value)

        value
      end
    end

    def call(data, *input)
      args = input.size == 1 && input[0].kind_of?(::Array) ? input[0] : input

      result = call!(data, args)

      return result unless block_given?

      yield(result) unless KIND.null?(result)
    end

    def presence(*args, &block)
      Presence.(call(*args, &block))
    end

    def [](*keys)
      ->(data) { call!(data, keys) }
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
