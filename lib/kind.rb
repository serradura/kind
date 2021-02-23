# frozen_string_literal: true

require 'set'
require 'ostruct'

require 'kind/version'
require 'kind/core'

require 'kind/error'
require 'kind/empty'
require 'kind/dig'
require 'kind/try'
require 'kind/presence'
require 'kind/undefined'
require 'kind/maybe'

require 'kind/type_checker'
require 'kind/type_checkers'

module Kind
  extend self

  def is?(kind, arg)
    KIND.is?(kind, arg)
  end

  alias is is?

  def of?(kind, *args)
    KIND.of?(kind, args)
  end

  def of_class?(value)
    KIND.of_class?(value)
  end

  def of_module?(value)
    KIND.of_module?(value)
  end

  def respond_to(value, *method_names)
    method_names.each { |method_name| KIND.respond_to!(method_name, value) }

    value
  end

  def of_module_or_class(value)
    KIND.of_module_or_class!(value)
  end

  def of(kind, object)
    KIND.of!(kind, object)
  end

  def value(kind, value, default:)
    KIND.value(kind, value, of(kind, default))
  end

  def Of(kind, opt = Empty::HASH)
    TypeChecker::Object.new(kind, opt)
  end
end
