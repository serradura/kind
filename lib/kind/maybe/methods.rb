# frozen_string_literal: true

module Kind
  module Maybe::Methods
    def Maybe(&block)
      Kind::Maybe.from(&block)
    end

    def None
      Kind::Maybe::NONE_INSTANCE
    end

    def Some(value = UNDEFINED, &block)
      UNDEFINED == value && block ? Maybe(&block) : Kind::Maybe[value]
    end

    def self.included(base)
      base.send(:private, :Some, :None)
    end
  end
end
