# frozen_string_literal: true

module Kind
  module Enum
    METHODS = \
    <<-RUBY
    def to_h
      ENUM__HASH
    end

    def items
      ENUM__ITEMS
    end

    def ===(arg)
      ENUM__ITEMS.any? { |item| item === arg }
    end

    def refs
      ENUM__REFS.to_a
    end

    def keys
      ENUM__KEYS.to_a
    end

    def values
      ENUM__VALS.to_a
    end

    def ref?(arg)
      ENUM__REFS.include?(arg)
    end

    def key?(arg)
      arg.respond_to?(:to_sym) ? ref?(arg) && !value?(arg) : false
    end

    def value?(arg)
      ENUM__VALS.include?(arg)
    end

    def [](arg)
      return arg if ref?(arg)

      raise KeyError, "key or value not found: %p" % [arg]
    end

    def ref(arg)
      arg if ref?(arg)
    end

    def item(arg)
      ENUM__MAP[arg]
    end

    def key(arg)
      item(arg).key if value?(arg)
    end

    def value_at(arg)
      item(arg).value if key?(arg)
    end

    def self.included(base)
      base.extend(base)
    end
    RUBY

    private_constant :METHODS
  end
end
