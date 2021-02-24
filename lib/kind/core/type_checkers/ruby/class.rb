# frozen_string_literal: true

module Kind
  module Class
    extend self, TypeChecker

    def kind; ::Class; end
  end

  def self.Class?(*values)
    KIND.of?(::Class, values)
  end
end
