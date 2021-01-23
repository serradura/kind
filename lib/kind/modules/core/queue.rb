# frozen_string_literal: true

module Kind
  module Queue
    extend self, Core::Checker

    def __kind__; ::Queue; end
    def __kind_name__; 'Queue'; end
  end

  def self.Queue?(*values)
    Core::Utils.kind_of?(::Queue, values)
  end
end
