# frozen_string_literal: true

module Kind
  module Set
    extend self, Core::Checker

    def kind; ::Set; end
  end

  def self.Set?(*values)
    Core::Utils.kind_of?(::Set, values)
  end
end
