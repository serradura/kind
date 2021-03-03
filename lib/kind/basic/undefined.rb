# frozen_string_literal: true

module Kind
  UNDEFINED = Object.new.tap do |undefined|
    def undefined.inspect
      @inspect ||= 'UNDEFINED'.freeze
    end

    undefined.inspect
    undefined.freeze
  end

  private_constant :UNDEFINED

  Undefined = Object.new.tap do |undefined|
    def undefined.inspect
      @inspect ||= 'Kind::Undefined'.freeze
    end

    def undefined.to_s
      inspect
    end

    def undefined.clone
      self
    end

    def undefined.dup
      clone
    end

    def undefined.default(value, default)
      return value if self != value

      default.respond_to?(:call) ? default.call : default
    end

    undefined.inspect
    undefined.freeze
  end
end