# frozen_string_literal: true

require 'kind/version'

require 'kind/__lib__/kind'
require 'kind/__lib__/undefined'

require 'kind/basic/undefined'
require 'kind/basic/error'

module Kind
  extend self

  def is?(kind, arg)
    KIND.is?(kind, arg)
  end

  def is(*args)
    warn '[DEPRECATION] Kind.is will behave like Kind.is! in the next major release; ' \
        'use Kind.is? instead.'

    is?(*args)
  end

  def is!(kind, arg, label: nil)
    return arg if KIND.is?(kind, arg)

    label_text = label ? "#{label}: " : ''

    raise Kind::Error.new("#{label_text}#{arg} expected to be a #{kind}")
  end

  def of?(kind, *args)
    KIND.of?(kind, args)
  end

  def of_class?(value)
    KIND.of_class?(value)
  end

  def of_module?(value)
    KIND.of_module?(value)
  end

  def respond_to?(value, *method_names)
    return super(value) if method_names.empty?

    KIND.interface?(method_names, value)
  end

  def of(kind, value, label: nil)
    return value if kind === value

    KIND.error!(kind.name, value, label)
  end

  alias_method :of!, :of

  def of_module_or_class(value)
    KIND.of_module_or_class!(value)
  end

  def respond_to(value, *method_names)
    method_names.each { |method_name| KIND.respond_to!(method_name, value) }

    value
  end
  alias_method :respond_to!, :respond_to

  def value(kind, value, default:)
    KIND.value(kind, value, of(kind, default))
  end
end
