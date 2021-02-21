# frozen_string_literal: true

module Kind
  module DEPRECATION # :nodoc: all
    WARN_IS_DISABLED = String(ENV['DISABLE_KIND_DEPRECATION']).strip == 't'

    module DevNull
      def self.warn(_)
      end
    end

    OUTPUT = WARN_IS_DISABLED ? DevNull : ::Kernel

    def self.warn(message)
      OUTPUT.warn("[DEPRECATION] #{message}" % { version: 'version 5.0' })
    end

    def self.warn_method_replacement(old_method, new_method)
      self.warn "`#{old_method}` is deprecated, it will be removed in %{version}. " \
        "Please use `#{new_method}` instead."
    end

    def self.warn_removal(name)
      self.warn "`#{name}` is deprecated, it will be removed in %{version}."
    end

    private_constant :DevNull, :OUTPUT
  end
end
