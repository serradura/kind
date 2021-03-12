# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Either
    require 'kind/either/monad'
    require 'kind/either/left'
    require 'kind/either/right'
    require 'kind/either/methods'

    extend self

    def new(value)
      Right[value]
    end

    alias_method :[], :new

    def self.from
      result = yield

      Either::Monad === result ? result : Either::Right[result]
    rescue StandardError => e
      Either::Left[e]
    end
  end

  extend Either::Methods
end
