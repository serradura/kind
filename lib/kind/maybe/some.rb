# frozen_string_literal: true

module Kind
  module Maybe
    class Some < Result
      def value_or(default = UNDEFINED, &block)
        @value
      end

      def none?; false; end

      def map(&fn)
        map!(&fn)
      rescue StandardError => exception
        None.new(exception)
      end

      alias_method :then, :map

      def check(&fn)
        result = fn.call(@value)

        !result || KIND.null?(result) ? NONE_WITH_NIL_VALUE : self
      end

      def map!(&fn)
        result = fn.call(@value)

        resolve(result)
      end

      alias_method :then!, :map!

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

      private

        def __try_method__(method_name, args)
          __try_block__(KIND.of!(::Symbol, method_name).to_proc, args)
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
    end

    VALUE_CANT_BE_NONE = "value can't be nil or Kind::Undefined".freeze

    def some(value)
      return Maybe::Some.new(value) if !KIND.null?(value)

      raise ArgumentError, VALUE_CANT_BE_NONE
    end

    private_constant :VALUE_CANT_BE_NONE
  end
end
