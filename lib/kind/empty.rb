# frozen_string_literal: true

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
