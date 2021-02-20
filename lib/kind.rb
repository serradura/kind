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
require 'kind/type_checker'

require 'kind/type_checkers'
require 'kind/maybe'

require 'kind/deprecations/checker'
require 'kind/deprecations/of'
require 'kind/deprecations/is'
require 'kind/deprecations/types'
require 'kind/deprecations/built_in_type_checkers'

module Kind
  def self.is?(kind, arg)
    KIND.is?(kind, arg)
  end

  def self.of?(kind, *args)
    KIND.of?(kind, args)
  end

  def self.of_class?(value)
    KIND.of_class?(value)
  end

  def self.of_module?(value)
    KIND.of_module?(value)
  end

  def self.respond_to(value, *method_names)
    method_names.each { |method_name| KIND.respond_to!(method_name, value) }

    value
  end

  def self.of_module_or_class(value)
    KIND.of_module_or_class!(value)
  end

  def self.is(expected = Undefined, object = Undefined)
    if Undefined == expected && Undefined == object
      DEPRECATION.warn('`Kind.is` without args is deprecated. This behavior will be removed in %{version}')

      return Is
    end

    return is?(expected, object) if Undefined != object

    raise ArgumentError, 'wrong number of arguments (given 1, expected 2)'
  end

  def self.of(kind = Undefined, object = Undefined)
    if Undefined == kind && Undefined == object
      DEPRECATION.warn('`Kind.of` without args is deprecated. This behavior will be removed in %{version}')

      Of
    elsif Undefined != object
      KIND.of!(kind, object)
    else
      DEPRECATION.warn_method_replacement('Kind.of(<Kind>)', 'Kind::Of(<Kind>)')

      Checker::Factory.create(kind)
    end
  end

  def self.Of(kind, opt = Empty::HASH)
    TypeChecker::Object.new(kind, opt)
  end
end
