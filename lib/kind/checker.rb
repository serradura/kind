# frozen_string_literal: true

require 'kind/checker/factory'
require 'kind/checker/protocol'
module Kind
  class Checker
    include Protocol

    attr_reader :__kind

    def initialize(kind)
      @__kind = kind
    end
  end
end
