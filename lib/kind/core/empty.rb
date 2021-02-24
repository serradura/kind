# frozen_string_literal: true

module Kind
  module Empty
    SET = ::Set.new.freeze
    HASH = {}.freeze
    ARRAY = [].freeze
    STRING = ''.freeze

    ARY = ARRAY
    STR = STRING
  end
end
