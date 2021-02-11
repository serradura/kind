# frozen_string_literal: true

module Kind
  module Try
    extend self

    def call(*args)
      object = args.shift

      return if KIND.null?(object)

      resolve(object, args.shift, args)
    end

    private

      def resolve(object, method_name, args = ::Kind::Empty::ARRAY)
        return unless object.respond_to?(method_name)
        return object.public_send(method_name) if args.empty?

        object.public_send(method_name, *args)
      end
  end
end
