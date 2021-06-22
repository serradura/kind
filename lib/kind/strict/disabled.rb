# frozen_string_literal: true

module Kind
  module STRICT
    [
      :object_is_a,
      :class!,
      :kind_of,
      :module_or_class,
      :module!,
      :not_nil,
      :in!,
      :assert_hash!
    ].each { |method_name| remove_method(method_name) }

    def object_is_a(_kind, value, _label = nil) # :nodoc:
      value
    end

    def class!(value) # :nodoc:
      value
    end

    def kind_of(_kind, value, _kind_name = nil) # :nodoc:
      value
    end

    def module_or_class(value) # :nodoc:
      value
    end

    def module!(value) # :nodoc:
      value
    end

    def not_nil(value, label) # :nodoc:
      value
    end

    def in!(list, value) # :nodoc:
      value
    end

    def assert_hash!(hash, _options) # :nodoc:
      hash
    end
  end
end
