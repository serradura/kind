# frozen_string_literal: true

require 'kind/basic'
require 'kind/__lib__/attributes'

module Kind
  module ImmutableAttributes
    require 'kind/immutable_attributes/initializer'
    require 'kind/immutable_attributes/reader'

    module ClassMethods
      def __attributes__ # :nodoc:
        @__attributes__ ||= {}
      end

      def attribute(name, kind = nil, default: UNDEFINED, visibility: :public)
        __attributes__[ATTRIBUTES.name!(name)] = ATTRIBUTES.value(kind, default, visibility)

        attr_reader(name)

        private(name) if visibility == :private
        protected(name) if visibility == :protected

        name
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, Reader)
      base.send(:include, Initializer)
    end
  end
end
