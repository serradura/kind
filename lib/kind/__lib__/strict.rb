# frozen_string_literal: true

require 'kind/__lib__/of'

module Kind
  module STRICT
    extend self

    require 'kind/__lib__/assert_hash'

    def error(kind_name, value, label = nil) # :nodoc:
      raise Error.new(kind_name, value, label: label)
    end

    def object_is_a(kind, value, label = nil, expected = nil) # :nodoc:
      return value if kind === value

      error(expected || kind.name, value, label)
    end

    def kind_of(kind, value, kind_name = nil) # :nodoc:
      return value if kind === value

      error(kind_name || kind.name, value)
    end

    def module_or_class(value) # :nodoc:
      kind_of(::Module, value, 'Module/Class')
    end

    def class!(value) # :nodoc:
      kind_of(::Class, value)
    end

    def module!(value) # :nodoc:
      return value if OF.module?(value)

      error('Module', value)
    end

    def not_nil(value, label) # :nodoc:
      return value unless value.nil?

      label_text = label ? "#{label}: " : ''

      raise Error.new("#{label_text}expected to not be nil")
    end

    def in!(list, value)
      return value if list.include?(value)

      raise Error.new("#{value} expected to be included in #{list.inspect}")
    end

    def assert_hash!(hash, options)
      check_keys = options.key?(:keys)
      check_schema = options.key?(:schema)

      raise ArgumentError, ':keys or :schema is missing' if !check_keys && !check_schema
      raise ArgumentError, "hash can't be empty" if hash.empty?

      require_all = options[:require_all]

      return assert_hash_keys!(hash, options[:keys], require_all) if check_keys

      assert_hash_schema!(hash, options[:schema], require_all)
    end

    private

      def assert_hash_keys!(hash, arg, require_all)
        keys = Array(arg)

        AssertHash::Keys.require_all(keys, hash) if require_all

        hash.each_key do |k|
          unless keys.include?(k)
            raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{keys.map(&:inspect).join(', ')}")
          end
        end
      end

      def assert_hash_schema!(hash, schema, require_all)
        return AssertHash::Schema.all(hash, schema) if require_all

        AssertHash::Schema.any(hash, schema)
      end
  end

  private_constant :STRICT
end
