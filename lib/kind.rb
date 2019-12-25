require "kind/version"

module Kind
  class Error < TypeError
    def initialize(klass, object)
      super("#{object} expected to be a kind of #{klass}")
    end
  end

  module Of
    def self.call(klass, object)
      return object if object.is_a?(klass)

      raise Kind::Error.new(klass, object)
    end

    def self.Class(object)
      self.call(::Class, object)
    end
  end

  module Is
    def self.call(expected, value)
      expected_klass, klass = Kind.of.Class(expected), Kind.of.Class(value)

      klass == expected_klass || klass < expected_klass
    end
  end

  def self.of; Of; end
  def self.is; Is; end

  module Types
    KIND_OF = <<-RUBY
      def self.%{klass}(object)
        Kind::Of.call(::%{klass}, object)
      end
    RUBY

    KIND_IS = <<-RUBY
      def self.%{klass}(value)
        Kind::Is.call(::%{klass}, value)
      end
    RUBY

    private_constant :KIND_OF, :KIND_IS

    def self.add(klass)
      klass_name = Kind.of.Class(klass).name

      return if Of.respond_to?(klass_name)

      Of.instance_eval(KIND_OF % { klass: klass_name })

      return if Is.respond_to?(klass_name)

      Is.instance_eval(KIND_IS % { klass: klass_name })
    end
  end

  [Hash, String]
    .each { |klass| Types.add(klass) }
end
