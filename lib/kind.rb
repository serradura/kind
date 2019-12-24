require "kind/version"

module Kind
  class Error < TypeError
    def initialize(klass, object)
      super("#{object} expected to be a kind of #{klass}")
    end
  end

  module Of
    def self.Class(object)
      return object if object.is_a?(::Class)
      raise Kind::Error.new(::Class, object)
    end
  end

  def self.of; Of; end

  module Types
    KIND_OF = <<-RUBY
      def self.%{klass}(object)
        return object if object.is_a?(::%{klass})
        raise Kind::Error.new(::%{klass}, object)
      end
    RUBY

    private_constant :KIND_OF

    def self.add(klass)
      klass_name = Kind.of.Class(klass).name

      return if Of.respond_to?(klass_name)

      Of.instance_eval(KIND_OF % { klass: klass_name })
    end
  end

  [Hash, String]
    .each { |klass| Types.add(klass) }
end
