# frozen_string_literal: true

module Kind
  class UnionType
    include Kind::BasicObject

    Interface = Kind::RespondTo[:name, :===]

    singleton_class.send(:alias_method, :[], :new)

    attr_reader :inspect

    def initialize(kind)
      @kinds = Array(kind)
      @inspect = "(#{@kinds.map(&:name).join(' | ')})"
    end

    def |(kind)
      self.class.new(@kinds + [Interface[kind.nil? ? Kind::Nil : kind]])
    end

    def ===(value)
      @kinds.any? { |kind| kind === value }
    end

    alias_method :name, :inspect

    module Buildable
      def |(another_kind)
        __union_type | another_kind
      end

      private

        def __union_type
          @__union_type ||= UnionType[self]
        end
    end

    private_constant :Interface
  end

  RespondTo.send(:include, UnionType::Buildable)
end
