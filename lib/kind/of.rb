# frozen_string_literal: true

module Kind
  module Of
    def self.call(kind, object, kind_name = nil)
      return object if kind === object

      raise Kind::Error.new(kind_name || kind.name, object)
    end
  end
end
