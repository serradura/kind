# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Result
    require 'kind/result/abstract'
    require 'kind/result/monad'
    require 'kind/result/failure'
    require 'kind/result/success'
    require 'kind/result/methods'

    def self.new(value)
      Success[value]
    end

    singleton_class.send(:alias_method, :[], :new)
  end

  extend Result::Methods
end
