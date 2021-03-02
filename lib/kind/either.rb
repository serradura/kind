# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Either
    require 'kind/either/monad'
    require 'kind/either/left'
    require 'kind/either/right'

    def self.new(value)
      Right[value]
    end

    singleton_class.send(:alias_method, :[], :new)
  end

  def self.Left(value)
    Either::Left.new(value)
  end

  def self.Right(value)
    Either::Right.new(value)
  end
end
