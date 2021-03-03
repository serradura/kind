# frozen_string_literal: true

module Kind
  module Time
    extend self, ::Kind::Object

    def kind; ::Time; end
  end

  def self.Time?(*values)
    KIND.of?(::Time, values)
  end
end
