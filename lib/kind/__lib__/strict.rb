# frozen_string_literal: true

require 'kind/__lib__/of'

module Kind
  module STRICT
    extend self

    def error(kind_name, value, label = nil) # :nodoc:
      raise Error.new(kind_name, value, label: label)
    end

    def object_is_a(kind, value, label = nil) # :nodoc:
      return value if kind === value

      error(kind.name, value, label)
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
      return assert_hash_keys!(hash, options[:keys]) if options.key?(:keys)

      raise ArgumentError, ':keys is missing'
    end

    private

      def assert_hash_keys!(hash, arg)
        keys = Array(arg)

        hash.each_key do |k|
          unless keys.include?(k)
            raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{keys.map(&:inspect).join(', ')}")
          end
        end
      end
  end

  private_constant :STRICT
end
