# frozen_string_literal: true

module Kind
  module Maybe
    require 'kind/core/maybe/monad'
    require 'kind/core/maybe/none'
    require 'kind/core/maybe/some'
    require 'kind/core/maybe/wrappable'
    require 'kind/core/maybe/typed'

    extend self

    def new(value)
      (::Exception === value || KIND.null?(value) ? None : Some)
        .new(value)
    end

    alias_method :[], :new

    extend Wrappable
  end

  Optional = Maybe

  None = Maybe::NONE_INSTANCE

  def self.None
    Maybe::NONE_INSTANCE
  end

  def self.Some(value)
    Maybe::Some[value]
  end

  def self.Maybe(kind)
    warn '[DEPRECATION] Kind::Maybe() is deprecated; use Kind::Maybe::Typed[] instead.' \
        'It will be removed on next major release.'

    Maybe::Typed[kind]
  end

  def self.Optional(kind)
    warn '[DEPRECATION] Kind::Optional() is deprecated; use Kind::Optional::Typed[] instead.' \
        'It will be removed on next major release.'

    Optional::Typed[kind]
  end
end
