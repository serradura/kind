# frozen_string_literal: true

require 'kind/dig'

module Kind
  module Maybe
    extend self

    require 'kind/maybe/result'
    require 'kind/maybe/none'
    require 'kind/maybe/some'
    require 'kind/maybe/wrappable'
    require 'kind/maybe/typed'

    def new(value)
      (Core::Utils.null?(value) ? None : Some)
        .new(value)
    end

    alias_method :[], :new

    extend Wrappable
  end

  Optional = Maybe

  None = Maybe.none

  def self.None
    Kind::None
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
