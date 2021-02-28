# frozen_string_literal: true

module Kind
  module Nil
    def self.|(another_kind)
      UnionType.new(self) | another_kind
    end

    def self.name
      'nil'
    end

    def self.===(value)
      value.nil?
    end
  end
end
