# frozen_string_literal: true

require 'kind/basic'

module Kind
  module Maybe
    require 'kind/maybe/monad'
    require 'kind/maybe/none'
    require 'kind/maybe/some'
    require 'kind/maybe/wrapper'
    require 'kind/maybe/typed'
    require 'kind/maybe/methods'

    extend self

    def new(value)
      (::Exception === value || KIND.nil_or_undefined?(value) ? None : Some)
        .new(value)
    end

    alias_method :[], :new

    module Buildable
      def maybe(value = UNDEFINED, &block)
        return __maybe[value] if UNDEFINED != value && !block
        return __maybe.wrap(&block) if UNDEFINED == value && block
        return __maybe.wrap(value, &block) if UNDEFINED != value && block

        __maybe
      end

      alias_method :optional, :maybe

      private

        def __maybe
          @__maybe ||= Maybe::Typed[self]
        end
    end

    extend Wrapper
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
    warn '[DEPRECATION] Kind::Maybe() is deprecated; use Kind::Maybe::Typed[] instead. ' \
        'It will be removed on next major release.'

    Maybe::Typed[kind]
  end

  def self.Optional(kind)
    warn '[DEPRECATION] Kind::Optional() is deprecated; use Kind::Optional::Typed[] instead. ' \
        'It will be removed on next major release.'

    Optional::Typed[kind]
  end
end
