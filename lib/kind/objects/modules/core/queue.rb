# frozen_string_literal: true

module Kind
  module Queue
    extend self, ::Kind::Object

    def kind; ::Queue; end
    def name; 'Queue'; end
  end

  def self.Queue?(*values)
    KIND.of?(::Queue, values)
  end
end
