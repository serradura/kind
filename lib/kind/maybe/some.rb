# frozen_string_literal: true

require 'kind/dig'
require 'kind/presence'

module Kind
  module Maybe
    class Some < Monad
      KindSymbol = ->(value) { KIND.of!(::Symbol, value) }

      VALUE_CANT_BE_NONE = "value can't be nil or Kind::Undefined".freeze

      def self.[](value)
        return new(value) if !KIND.null?(value)

        raise ArgumentError, VALUE_CANT_BE_NONE
      end

      def value_or(_default = UNDEFINED, &block)
        @value
      end

      def none?; false; end

      def map(method_name = UNDEFINED, &fn)
        map!(method_name, &fn)
      rescue StandardError => exception
        None.new(exception)
      end

      alias_method :then, :map
      alias_method :and_then, :map

      def map!(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          return NONE_INSTANCE unless @value.respond_to?(KindSymbol[method_name])

          @value.public_send(method_name)
        else
          fn.call(@value)
        end

        resolve(result)
      end

      alias_method :then!, :map!
      alias_method :and_then!, :map!

      def check(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          if method_name.kind_of?(::Symbol)
            @value.respond_to?(method_name) ? @value.public_send(method_name) : NONE_INSTANCE
          else
            method_name === @value
          end
        else
          fn.call(@value)
        end

        !result || KIND.null?(result) ? NONE_INSTANCE : self
      end

      alias_method :accept, :check

      def reject(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          if method_name.kind_of?(::Symbol)
            @value.respond_to?(method_name) ? @value.public_send(method_name) : NONE_INSTANCE
          else
            method_name === @value
          end
        else
          fn.call(@value)
        end

        result || KIND.null?(result) ? NONE_INSTANCE : self
      end

      def try!(method_name = UNDEFINED, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if UNDEFINED != method_name

        raise ArgumentError, 'method name or a block must be present'
      end

      def try(method_name = UNDEFINED, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if value.respond_to?(method_name)

        NONE_INSTANCE
      rescue TypeError
        NONE_INSTANCE
      end

      def dig(*keys)
        resolve(Dig.call!(value, keys))
      end

      def presence
        resolve(Presence.(value))
      end

      def inspect
        '#<%s value=%s>' % ['Kind::Some', value.inspect]
      end

      private

        def __try_method__(method_name, args)
          __try_block__(KindSymbol[method_name].to_proc, args)
        end

        def __try_block__(block, args)
          result = args.empty? ? block.call(value) : block.call(*args.unshift(value))

          resolve(result)
        end

        def resolve(result)
          return result if Maybe::None === result
          return NONE_INSTANCE if KIND.null?(result)
          return None.new(result) if ::Exception === result

          Some.new(result)
        end

        private_constant :KindSymbol, :VALUE_CANT_BE_NONE
    end
  end
end
