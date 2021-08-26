# frozen_string_literal: true

module Kind
  module ID
    extend self, ::Kind::Object

    def kind; [::Integer, ::String]; end

    def name; 'ID'; end

    def ===(value)
      value.kind_of?(::Integer) && value.positive? ||
        value.kind_of?(::String) && value =~ /^\d+$/ && value.to_i.positive? ||
        value.kind_of?(::String) && /\A[\da-f]{32}\z/i.match?(value) ||
        value.kind_of?(::String) && /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i.match?(value)
    end
  end

  def self.ID?(*values)
    KIND.of?(ID, values)
  end
end
