# frozen_string_literal: true

module Kind
  module Result::Methods
    def Failure(arg1 = UNDEFINED, arg2 = UNDEFINED)
      Result::Failure[arg1, arg2]
    end

    def Success(arg1 = UNDEFINED, arg2 = UNDEFINED)
      Result::Success[arg1, arg2]
    end

    def self.included(base)
      base.send(:private, :Success, :Failure)
    end
  end
end
