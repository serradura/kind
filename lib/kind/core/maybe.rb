# frozen_string_literal: true

module Kind
  module Maybe
    require 'kind/core/maybe/result'
    require 'kind/core/maybe/none'
    require 'kind/core/maybe/some'
    require 'kind/core/maybe/wrappable'
    require 'kind/core/maybe/typed'

    extend self

    def new(value)
      (Exception === value || KIND.null?(value) ? None : Some)
        .new(value)
    end

    alias_method :[], :new

    extend Wrappable
  end

  Optional = Maybe

  None = Maybe.none

  def self.None
    None
  end

  def self.Some(value)
    Maybe.some(value)
  end

  def self.Maybe(kind)
    Maybe::Typed.new(kind)
  end

  def self.Optional(kind)
    Maybe::Typed.new(kind)
  end
end
