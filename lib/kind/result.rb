# frozen_string_literal: true

require 'kind'

module Kind
  module Result
    require 'kind/result/wrapper'
    require 'kind/result/object'
    require 'kind/result/failure'
    require 'kind/result/success'

    def self.build(result, arg1, arg2, default_type:) # :nodoc:
      type = UNDEFINED == arg2 ? default_type : Kind::Symbol[arg1]

      ARGS_ERROR.wrong_number!(given: 0, expected: '1 or 2') if UNDEFINED == arg1

      value = UNDEFINED == arg2 ? arg1 : arg2

      result.new(type, value)
    end
  end

  def self.Failure(arg1 = UNDEFINED, arg2 = UNDEFINED)
    Result.build(Result::Failure, arg1, arg2, default_type: :error)
  end

  def self.Success(arg1 = UNDEFINED, arg2 = UNDEFINED)
    Result.build(Result::Success, arg1, arg2, default_type: :ok)
  end
end
