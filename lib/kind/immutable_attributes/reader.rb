# frozen_string_literal: true

require 'kind/basic'
require 'kind/__lib__/attributes'

module Kind
  module ImmutableAttributes

    module Reader
      def self.included(base)
        base.send(:attr_reader, :attributes)
      end

      def attribute?(name)
        self.class.__attributes__.key?(name.to_sym)
      end

      def attribute(name)
        @attributes[name.to_sym]
      end

      def attribute!(name)
        @attributes.fetch(name.to_sym)
      end

      def with_attribute(name, value)
        self.class.new(@_____attrs.merge(name.to_sym => value))
      end

      def with_attributes(arg)
        hash = STRICT.kind_of(::Hash, arg)

        self.class.new(@_____attrs.merge(hash))
      end
    end

  end
end
