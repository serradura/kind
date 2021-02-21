# frozen_string_literal: true

module Kind
  module Maybe
    class Typed
      include Wrappable

      def initialize(kind)
        @kind = kind
      end

      def new(value)
        value.kind_of?(@kind) ? Maybe.some(value) : Maybe.none
      end

      alias_method :[], :new
    end
  end
end
