# frozen_string_literal: true

module Kind
  module Callable
    extend self, TypeChecker

    def kind; raise NotImplementedError; end

    def name; 'Callable'; end

    def ===(value)
      value.respond_to?(:call)
    end
  end

  def self.Callable?(*values)
    KIND.of?(Callable, values)
  end
end
