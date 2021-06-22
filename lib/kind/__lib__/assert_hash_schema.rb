# frozen_string_literal: true

module Kind
  module ASSERT_HASH_KEYS
    def self.require_all(keys, hash)
      expected_keys = keys - hash.keys

      unless expected_keys.empty?
        raise KeyError.new("#{hash.inspect} expected to have these keys: #{expected_keys}")
      end

      unexpected_keys = hash.keys - keys

      unless unexpected_keys.empty?
        raise KeyError.new("#{hash.inspect} expected to NOT have these keys: #{unexpected_keys}")
      end

      hash
    end
  end

  module ASSERT_HASH_SCHEMA
    extend self

    UnionType = ->(value) do
      defined?(Kind::UnionType) ? Kind::UnionType === value : false
    end

    def any(hash, spec)
      spec.each do |key, expected|
        value = hash[key]
        error_message = "The key #{key.inspect} has an invalid value"

        case expected
        when ::Module then assert_kind_of(expected, value, error_message)
        when ::Proc then assert(expected.call(value), error_message)
        when ::Regexp then assert_match(expected, value, error_message)
        when ::NilClass then assert_nil(value, error_message)
        when UnionType then assert(expected === value, error_message)
        else assert_equal(expected, value, error_message)
        end
      end

      hash
    end

    def all(hash, spec)
      ASSERT_HASH_KEYS.require_all(spec.keys, hash)

      any(hash, spec)
    end

    private

      def assert_equal(expected, value, message)
        raise_kind_error(message) if expected != value
      end

      def assert(value, message)
        raise_kind_error(message) unless value
      end

      def assert_nil(value, message)
        raise_kind_error(message) unless value.nil?
      end

      def assert_match(expected, value, message)
        STRICT.kind_of(String, value)

        raise_kind_error(message) if value !~ expected
      end

      def assert_kind_of(expected, value, message)
        raise_kind_error(message) unless expected === value
      end

      def raise_kind_error(message)
        raise Error.new(message)
      end
  end
end
