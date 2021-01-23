# frozen_string_literal: true

module Kind
  module Of
    def self.call(kind, object, kind_name = nil)
      warn "[DEPRECATION] `Kind::Of.call` is deprecated.  Please use `Kind::Core::Utils.kind_of!` instead."
      Core::Utils.kind_of!(kind, object, kind_name)
    end
  end
end
