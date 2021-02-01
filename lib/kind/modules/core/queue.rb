# frozen_string_literal: true

module Kind
  module Queue
    extend self, Core::Checker

    def kind; ::Queue; end
    def name; 'Queue'; end
  end

  def self.Queue?(*values)
    Core::Utils.kind_of?(::Queue, values)
  end
end
