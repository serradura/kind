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
end
