# frozen_string_literal: true

require 'kind/basic'
require 'kind/empty'
require 'kind/presence'

module Kind
  module Try
    extend self

    def call!(object, method_name, args = Empty::ARRAY) # :nodoc
      return if KIND.null?(object)

      resolve(object, method_name, args)
    end

    def call(object, *input)
      args = input.size == 1 && input[0].kind_of?(::Array) ? input[0] : input

      result = call!(object, args.shift, args)

      return result unless block_given?

      yield(result) unless KIND.null?(result)
    end

    def presence(*args, &block)
      Presence.(call(*args, &block))
    end

    def self.[](*args)
      method_name = args.shift

      ->(object) { call!(object, method_name, args) }
    end

    private

      def resolve(object, method_name, args)
        return unless object.respond_to?(method_name)
        return object.public_send(method_name) if args.empty?

        object.public_send(method_name, *args)
      end
  end
end
