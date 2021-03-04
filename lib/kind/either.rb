# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Either
    require 'kind/either/monad'
    require 'kind/either/left'
    require 'kind/either/right'
    require 'kind/either/methods'

    def self.new(value)
      Right[value]
    end

    singleton_class.send(:alias_method, :[], :new)
  end

  extend Either::Methods
end
