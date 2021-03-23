# frozen_string_literal: true

module Kind
  module OF
    extend self

    def class?(value) # :nodoc:
      value.kind_of?(::Class)
    end

    def module?(value) # :nodoc:
      ::Module == value || (value.kind_of?(::Module) && !class?(value))
    end
  end

  private_constant :OF
end
