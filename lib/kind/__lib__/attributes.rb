# frozen_string_literal: true

require 'kind/__lib__/kind'
require 'kind/__lib__/undefined'

module Kind
  module ATTRIBUTES
    extend self

    def name!(name)
      KIND.of!(::Symbol, name)
    end

    def value(kind, default, visibility = :private)
      [kind, default, visibility]
    end

    def value_to_assign(kind, default, hash, name)
      raw_value = hash[name]

      return raw_value if kind.nil? && UNDEFINED == default

      value = resolve_value_to_assign(kind, default, raw_value)

      (kind.nil? || kind === value) ? value : nil
    end

    def value!(kind, default)
      return value(kind, default) unless kind.nil?

      raise Error.new("kind expected to not be nil")
    end

    def value_to_assign!(kind, default, hash, name)
      value = resolve_value_to_assign(kind, default, hash[name])

      Kind.of(kind, value, label: name)
    end

    private

      def resolve_value_to_assign(kind, default, value)
        if kind == ::Proc
          UNDEFINED == default ? value : KIND.value(kind, value, default)
        else
          default_is_a_callable = default.respond_to?(:call)

          default_value =
            if default_is_a_callable
              default_fn = Proc === default ? default : default.method(:call)

              default_fn.arity != 0 ? default_fn.call(value) : default_fn.call
            else
              default
            end

          return value if UNDEFINED == default_value
          return default_value || value if kind.nil?

          default_is_a_callable ? KIND.value(kind, default_value, value) : KIND.value(kind, value, default_value)
        end
      end
  end

  private_constant :ATTRIBUTES
end
