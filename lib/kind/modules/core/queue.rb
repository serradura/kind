# frozen_string_literal: true

module Kind
  module Queue
    extend self, CheckerMethods

    def __kind__; ::Queue; end
    def __kind_name__; 'Queue'; end
  end

  def self.Queue?(*values)
    CheckerUtils.kind_of?(::Queue, values)
  end
end
