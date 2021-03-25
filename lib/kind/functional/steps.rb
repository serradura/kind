# frozen_string_literal: true

require 'kind/basic'
require 'kind/empty'
require 'kind/result'
require 'kind/__lib__/action_steps'

module Kind
  module Functional
    module Steps
      def self.extended(base)
        base.extend(Result::Methods)
        base.extend(ACTION_STEPS)
      end

      def self.included(base)
        base.send(:include, Result::Methods)
        base.send(:include, ACTION_STEPS)
      end
    end
  end
end
