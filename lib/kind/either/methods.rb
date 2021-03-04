# frozen_string_literal: true

module Kind
  module Either::Methods
    def Left(value)
      Either::Left[value]
    end

    def Right(value)
      Either::Right[value]
    end

    def self.included(base)
      base.send(:private, :Left, :Right)
    end
  end
end
