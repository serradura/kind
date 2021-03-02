# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Result
    require 'kind/result/monad'
    require 'kind/result/failure'
    require 'kind/result/success'

    def self.new(value)
      Success[value]
    end

    singleton_class.send(:alias_method, :[], :new)
  end

  def self.Failure(arg1 = UNDEFINED, arg2 = UNDEFINED)
    Result::Failure[arg1, arg2]
  end

  def self.Success(arg1 = UNDEFINED, arg2 = UNDEFINED)
    Result::Success[arg1, arg2]
  end
end
