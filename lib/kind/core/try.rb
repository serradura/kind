# frozen_string_literal: true

module Kind
  module Try
    extend self

    def call(*args)
      object = args.shift

      call!(object, args.shift, args)
    end

    def self.[](*args)
      method_name = args.shift

      ->(object) { call!(object, method_name, args) }
    end

    def call!(object, method_name, args) # :nodoc
      return if KIND.null?(object)

      resolve(object, method_name, args)
    end

    private

      def resolve(object, method_name, args = Empty::ARRAY)
        return unless object.respond_to?(method_name)
        return object.public_send(method_name) if args.empty?

        object.public_send(method_name, *args)
      end
  end
end
