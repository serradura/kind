# frozen_string_literal: true

module Kind
  module Is
    def self.call(expected, object)
      warn "[DEPRECATION] `Kind::Is.call` is deprecated.  Please use `Kind::Core::Utils.is?` instead."
      Core::Utils.is?(expected, object)
    end
  end
end
