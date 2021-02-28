# frozen_string_literal: true

require 'kind'

module Kind
  module Either
    require 'kind/either/result'
    require 'kind/either/left'
    require 'kind/either/right'
  end

  def self.Left(value)
    Either::Left.new(value)
  end

  def self.Right(value)
    Either::Right.new(value)
  end
end
