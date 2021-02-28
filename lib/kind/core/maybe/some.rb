# frozen_string_literal: true

module Kind
  module Maybe
    class Some < Result
      KindSymbol = ->(value) { KIND.of!(::Symbol, value) }

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

      def map!(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          return NONE_WITH_NIL_VALUE unless @value.respond_to?(KindSymbol[method_name])

          @value.public_send(method_name)
        else
          fn.call(@value)
        end

        resolve(result)
      end

      alias_method :then!, :map!

      def check(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          return NONE_WITH_NIL_VALUE unless @value.respond_to?(KindSymbol[method_name])

          @value.public_send(method_name)
        else
          fn.call(@value)
        end

        !result || KIND.null?(result) ? NONE_WITH_NIL_VALUE : self
      end

      alias_method :accept, :check

      def reject(method_name = UNDEFINED, &fn)
        result = if UNDEFINED != method_name
          return NONE_WITH_NIL_VALUE unless @value.respond_to?(KindSymbol[method_name])

          @value.public_send(method_name)
        else
          fn.call(@value)
        end

        result || KIND.null?(result) ? NONE_WITH_NIL_VALUE : self
      end

      def try!(method_name = UNDEFINED, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if UNDEFINED != method_name

        raise ArgumentError, 'method name or a block must be present'
      end

      def try(method_name = UNDEFINED, *args, &block)
        return __try_block__(block, args) if block

        return __try_method__(method_name, args) if value.respond_to?(method_name)

        NONE_WITH_NIL_VALUE
      end

      def dig(*keys)
        resolve(Dig.(value, keys))
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
          return None.new(result) if Exception === result
          return NONE_WITH_NIL_VALUE if result.nil?
          return NONE_WITH_UNDEFINED_VALUE if Undefined == result

          Some.new(result)
        end

      private_constant :KindSymbol
    end

    VALUE_CANT_BE_NONE = "value can't be nil or Kind::Undefined".freeze

    def self.some(value)
      return Maybe::Some.new(value) if !KIND.null?(value)

      raise ArgumentError, VALUE_CANT_BE_NONE
    end

    private_constant :VALUE_CANT_BE_NONE
  end
end
