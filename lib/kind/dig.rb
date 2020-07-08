# frozen_string_literal: true

module Kind
  module Dig
    extend self

    def call(data, keys)
      return unless keys.is_a?(Array)

      keys.reduce(data) do |memo, key|
        value = get(memo, key)

        break if value.nil?

        value
      end
    end

    private

      def get(data, key)
        return data[key] if Hash === data

        case data
        when Array
          data[key] if key.respond_to?(:to_int)
        when OpenStruct
          data[key] if key.respond_to?(:to_sym)
        when Struct
          if key.respond_to?(:to_int) || key.respond_to?(:to_sym)
            data[key] rescue nil
          end
        end
      end
  end
end
