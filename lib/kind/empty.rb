# frozen_string_literal: true

require 'set'

module Kind
  module Empty
    SET = ::Set.new.freeze

    HASH = {}.freeze

    ARY = [].freeze
    ARRAY = ARY

    STR = ''.freeze
    STRING = STR
  end
end

unless defined?(Empty)
  Empty = Kind::Empty
end
