# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Result
    require 'kind/result/abstract'
    require 'kind/result/monad'
    require 'kind/result/failure'
    require 'kind/result/success'
    require 'kind/result/methods'

    extend self

    def new(value)
      Success[value]
    end

    alias_method :[], :new

    def self.from
      result = yield

      Result::Monad === result ? result : Result::Success[result]
    rescue StandardError => e
      Result::Failure[:exception, e]
    end
  end

  extend Result::Methods
end
