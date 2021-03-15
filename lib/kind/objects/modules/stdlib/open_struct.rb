# frozen_string_literal: true

require 'ostruct'

module Kind
  module OpenStruct
    extend self, ::Kind::Object

    def kind; ::OpenStruct; end
  end

  def self.OpenStruct?(*values)
    KIND.of?(::OpenStruct, values)
  end
end
