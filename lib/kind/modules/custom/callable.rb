# frozen_string_literal: true

module Kind
  module Callable
    extend self, Core::Checker

    def kind; raise NotImplementedError; end

    def name; 'Callable'; end

    def instance?(value)
      value.respond_to?(:call)
    end
  end

  def self.Callable?(*values)
    Core::Utils.kind?(of: values, by: -> value {
      Callable.instance?(value)
    })
  end
end
