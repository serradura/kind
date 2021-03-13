# frozen_string_literal: true

require 'kind/__lib__/attributes'
require 'kind/basic'
require 'kind/empty'

module Kind
  module ImmutableAttributes
    module Initializer
      def initialize(arg)
        input = __resolve_attribute_input(arg)

        hash = call_before_initialize_to_prepare_the_input(input)

        @_nil_attrs = ::Set.new
        @_____attrs = {}
        @attributes = {}

        self.class.__attributes__.each do |name, (kind, default, visibility)|
          value_to_assign = __resolve_attribute_value_to_assign(kind, default, hash, name)

          @_nil_attrs << name if value_to_assign.nil?
          @_____attrs[name] = value_to_assign
          @attributes[name] = value_to_assign if visibility == :public

          instance_variable_set("@#{name}", value_to_assign)
        end

        @_nil_attrs.freeze
        @attributes.freeze

        call_after_initialize_and_assign_the_attributes
      end

      def nil_attributes
        @_nil_attrs.to_a
      end

      def nil_attributes?(*names)
        names.empty? ? !@_nil_attrs.empty? : names.all? { |name| @_nil_attrs.include?(name) }
      end

      private

        def call_before_initialize_to_prepare_the_input(input)
          input
        end

        def call_after_initialize_and_assign_the_attributes
        end

        def __resolve_attribute_input(arg)
          return arg.attributes if arg.kind_of?(ImmutableAttributes)

          arg.kind_of?(::Hash) ? arg : Empty::HASH
        end

        def __resolve_attribute_value_to_assign(kind, default, hash, name)
          if kind.kind_of?(::Class) && kind < ImmutableAttributes
            kind.new(hash[name])
          elsif kind.kind_of?(::Array) && (nkind = kind[0]).kind_of?(::Class) && nkind < ImmutableAttributes
            Array(hash[name]).map { |item| nkind.new(item) }
          else
            ATTRIBUTES.value_to_assign(kind, default, hash, name)
          end
        end
    end

  end
end
