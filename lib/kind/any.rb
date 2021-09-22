# frozen_string_literal: true

module Kind
  class Any
    FilledArray = ->(value) {value.is_a?(::Array) && !value.empty?}

    singleton_class.send(:alias_method, :[], :new)

    attr_reader :values

    def initialize(*args)
      array = args.size == 1 ? args[0] : args

      @values = Kind.of(FilledArray, array, expected: 'filled array')
    end

    def ===(other)
      @values.any? { |value| value == other }
    end

    def [](value, label: nil)
      STRICT.object_is_a(self, value, label)
    end

    def |(another_kind)
      UnionType[self] | another_kind
    end

    def name
      "Kind::Any#{@values}"
    end

    alias inspect name

    private_constant :FilledArray
  end
end
