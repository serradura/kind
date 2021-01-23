# frozen_string_literal: true

require 'kind/version'

require 'set'
require 'ostruct'

require 'kind/core'
require 'kind/empty'
require 'kind/error'
require 'kind/undefined'

require 'kind/modules'
require 'kind/maybe'

require 'kind/deprecation/checker'
require 'kind/deprecation/of'
require 'kind/deprecation/is'
require 'kind/deprecation/types'
require 'kind/deprecation/built_in_type_checkers'

module Kind
  def self.of?(kind, *args)
    Core::Utils.kind_of?(kind, args)
  end

  def self.of_class?(value)
    Core::Utils.kind_of_class?(value)
  end

  def self.of_module?(value)
    Core::Utils.kind_of_module?(value)
  end

  def self.of_module_or_class!(value)
    Core::Utils.kind_of_module_or_class!(value)
  end

  def self.is(expected = Undefined, object = Undefined)
    return Is if Undefined == expected && Undefined == object

    return Core::Utils.kind_is?(expected, object) if Undefined != object

    raise ArgumentError, 'wrong number of arguments (given 1, expected 2)'
  end

  def self.of(kind = Undefined, object = Undefined)
    return Of if Undefined == kind && Undefined == object

    return Core::Utils.kind_of!(kind, object) if Undefined != object

    Kind::Checker::Factory.create(kind)
  end
end
