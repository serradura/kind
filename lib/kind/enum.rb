# frozen_string_literal: true

require 'set'
require 'kind/basic'

module Kind
  module Enum
    require 'kind/enum/item'
    require 'kind/enum/methods'

    extend self

    def values(input)
      __create(input)
    end

    def from_array(input, use_index_as_value:)
      __create(input, use_index_as_value)
    end

    private

      def __create(input, use_index_as_value = true)
        enum_module = ::Module.new

        enum_items =
          case input
          when ::Hash then __create_from_hash(input)
          when ::Array then __create_from_array(input, use_index_as_value)
          else raise ArgumentError, 'use an array or hash to define a Kind::Enum'
          end

        enum_items.each { |item| enum_module.const_set(item.name, item) }

        enum_map = enum_items.each_with_object({}) do |item, memo|
          memo[item.to_s] = item
          memo[item.value] = item
          memo[item.to_sym] = item
        end

        enum_module.const_set(:ENUM__MAP, enum_map)
        enum_module.const_set(:ENUM__HASH, enum_items.map(&:to_ary).to_h.freeze)
        enum_module.const_set(:ENUM__KEYS, ::Set.new(enum_items.map(&:key)).freeze)
        enum_module.const_set(:ENUM__VALS, ::Set.new(enum_items.map(&:value)).freeze)
        enum_module.const_set(:ENUM__REFS, ::Set.new(enum_map.keys))
        enum_module.const_set(:ENUM__ITEMS, enum_items.freeze)

        enum_module.send(:private_constant, :ENUM__MAP, :ENUM__HASH, :ENUM__KEYS,
                                            :ENUM__VALS, :ENUM__REFS, :ENUM__ITEMS)

        enum_module.module_eval(METHODS)

        enum_module.extend(enum_module)
        enum_module
      end

      def __create_from_hash(input)
        input.map { |key, value| __item(key, value) }
      end

      def __create_from_array(input, use_index_as_value)
        input.map.with_index { |key, index| use_index_as_value ? __item(key, index) : __item(key, key) }
      end

      def __item(key, value)
        return Item.new(key, value) if key.respond_to?(:to_sym)

        raise ArgumentError, 'use a string or symbol to define a Kind::Enum item'
      end
  end
end
