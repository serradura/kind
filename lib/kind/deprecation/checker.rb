# frozen_string_literal: true

require 'kind/deprecation/checker/factory'
require 'kind/deprecation/checker/protocol'

module Kind
  class Checker
    include Protocol

    attr_reader :__kind

    def initialize(kind)
      @__kind = kind
    end
  end
end
