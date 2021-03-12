# frozen_string_literal: true

require 'kind/try'
require 'kind/maybe'

require 'kind/objects/basic_object'
require 'kind/objects/respond_to'
require 'kind/objects/union_type'
require 'kind/objects/nil'
require 'kind/objects/not_nil'
require 'kind/objects/object'
require 'kind/objects/modules'

module Kind
  UnionType.send(:include, Maybe::Buildable)
  RespondTo.send(:include, Maybe::Buildable)
end
