# frozen_string_literal: true

module Kind
  module Types
    extend self

    COLONS = '::'.freeze

    KIND_OF = <<-RUBY
      def self.%{method_name}(object = Undefined, options = {})
        default = options[:or]

        return Kind::Of::%{kind_name} if object == Undefined && default.nil?

        Kind::Of.(::%{kind_name}, (object || default), name: "%{kind_name}".freeze)
      end
    RUBY

    KIND_IS = <<-RUBY
      def self.%{method_name}(value = Undefined)
        return Kind::Is::%{kind_name} if value == Undefined

        Kind::Is.(::%{kind_name}, value)
      end
    RUBY

    private_constant :KIND_OF, :KIND_IS, :COLONS

    def add(kind, name: nil)
      kind_name = Kind.of.Module(kind).name
      checker = name ? Kind::Of.(String, name) : kind_name

      case
      when checker.include?(COLONS)
        add_kind_with_namespace(checker, method_name: name)
      else
        add_root(checker, kind_name, method_name: name, create_kind_is_mod: false)
      end
    end

    private

      def add_root(checker, kind_name, method_name:, create_kind_is_mod:)
        root_checker = method_name ? method_name : checker
        root_kind_name = method_name ? method_name : kind_name

        add_kind(root_checker, root_kind_name, Kind::Of, Kind::Is, create_kind_is_mod)
      end

      def add_kind_with_namespace(checker, method_name:)
        raise NotImplementedError if method_name

        const_names = checker.split(COLONS)
        const_names.each_with_index do |const_name, index|
          if index == 0
            add_root(const_name, const_name, method_name: nil, create_kind_is_mod: true)
          else
            add_node(const_names, index)
          end
        end
      end

      def add_node(const_names, index)
        namespace = const_names[0..(index-1)]
        namespace_name = namespace.join(COLONS)

        kind_of_mod = Kind::Of.const_get(namespace_name)
        kind_is_mod = Kind::Is.const_get(namespace_name)

        checker = const_names[index]
        kind_name = const_names[0..index].join(COLONS)

        add_kind(checker, kind_name, kind_of_mod, kind_is_mod, true)
      end

      def add_kind(checker, kind_name, kind_of_mod, kind_is_mod, create_kind_is_mod)
        params = { method_name: checker, kind_name: kind_name }

        unless kind_of_mod.respond_to?(checker)
          kind_checker = ::Module.new { extend Checker }
          kind_checker.module_eval("def self.__kind; #{kind_name}; end")

          kind_of_mod.instance_eval(KIND_OF % params)
          kind_of_mod.const_set(checker, kind_checker)
        end

        unless kind_is_mod.respond_to?(checker)
          kind_is_mod.instance_eval(KIND_IS % params)
          kind_is_mod.const_set(checker, Module.new) if create_kind_is_mod
        end
      end
  end
end
