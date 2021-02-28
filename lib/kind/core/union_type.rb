# frozen_string_literal: true

module Kind
  class UnionType
    Interface = Kind::RespondTo[:name, :===]

    def initialize(kind)
      @kinds = Array(kind)
      @inspect = "(#{@kinds.map(&:name).join(' | ')})"
    end

    def |(kind)
      self.class.new(@kinds + [Interface[kind]])
    end

    def ===(value)
      @kinds.any? { |kind| kind === value }
    end

    def [](value)
      return value if self.===(value)

      KIND.error!(@inspect, value)
    end

    def inspect
      @inspect
    end

    alias_method :name, :inspect

    private_constant :Interface
  end
end
