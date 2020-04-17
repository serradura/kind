# frozen_string_literal: true

module Kind
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
      return self if value != self

      default.respond_to?(:call) ? default.call : default
    end
  end
end
