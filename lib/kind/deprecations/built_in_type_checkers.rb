# frozen_string_literal: true

module Kind
  # -- Classes
  [
    ::String, ::Symbol, ::Numeric, ::Integer, ::Float, ::Regexp, ::Time,
    ::Array, ::Range, ::Hash, ::Struct, ::Enumerator, ::Set, ::OpenStruct,
    ::Method, ::Proc,
    ::IO, ::File
  ].each { |klass| Types.add(klass) }

  Types.add(::Queue, name: 'Queue'.freeze)

  # -- Modules
  [
    ::Enumerable, ::Comparable
  ].each { |klass| Types.add(klass) }

  # -- Kind::Of::Maybe

  Types.add(Kind::Maybe::Result, name: 'Maybe'.freeze)
  Types.add(Kind::Maybe::Result, name: 'Optional'.freeze)
end
