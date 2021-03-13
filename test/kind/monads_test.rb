require 'test_helper'

class Kind::MonadsTest < Minitest::Test
  require 'kind/maybe'
  require 'kind/result'

  class User
    attr_reader :id, :name

    def self.find_by(id:)
      id_int = id.to_i

      new(id_int, 'John Doe') if id_int == 2
    end

    def initialize(id, name)
      @id = id
      @name = name
    end

    def update(params)
      Kind::Maybe[params[:name]].then(:strip).presence.on do |result|
        result.none { false }
        result.some { |name| @name = name and true }
      end
    end

    def errors
      OpenStruct.new(full_messages: ["Name can't be blank"])
    end
  end

  module User::Find
    extend self, Kind::Maybe::Methods, Kind::Result::Methods

    def call(input)
      fetch_user_id_from(input)
        .and_then { |id| find_user_by(id) }
        .value_or { Failure(message: "input must be a hash with a filled :id") }
    end

    private

      def fetch_user_id_from(input)
        Some(input).accept(Hash).dig(:id).presence.check(Kind[String] | Integer)
      end

      def find_user_by(id)
        Maybe { User.find_by(id: id) }
          .and_then { |user| Success(user: user) }
          .value_or { Failure(message: "user not found") }
      end
  end

  def test_multiple_methods_in_a_module
    [nil, [], {}, {id: ''}].each do |input|
      result = User::Find.call(input)

      assert result.failure?
      assert_equal("input must be a hash with a filled :id", result.value[:message])
    end

    # --

    [{id: 1}, {id: '1'}].each do |input|
      result = User::Find.call(input)

      assert result.failure?
      assert_equal("user not found", result.value[:message])
    end

    # --

    [{id: 2}, {id: '2'}].each do |input|
      result = User::Find.call(input)

      assert result.success?
      assert_equal('John Doe', result.value[:user].name)
    end
  end

  class User::Finder
    include Kind::Maybe::Methods, Kind::Result::Methods

    def call(input)
      Some(input).try(:[], :id).presence
        .then     { |id| find_user_by(id) }
        .value_or { Failure(message: "input must be a hash with a filled :id") }
    end

    private

      def find_user_by(id)
        Some { User.find_by(id: id) }
          .then     { |user| Success(user: user) }
          .value_or { Failure(message: "user not found") }
      end
  end

  def test_multiple_methods_in_a_lambda
    find_user = User::Finder.new

    [nil, [], {}, {id: ''}].each do |input|
      result = find_user.call(input)

      assert result.failure?
      assert_equal("input must be a hash with a filled :id", result.value[:message])
    end

    # --

    [{id: 1}, {id: '1'}].each do |input|
      result = find_user.call(input)

      assert result.failure?
      assert_equal("user not found", result.value[:message])
    end

    # --

    [{id: 2}, {id: '2'}].each do |input|
      result = find_user.call(input)

      assert result.success?
      assert_equal('John Doe', result.value[:user].name)
    end
  end

  module Nothing1
    extend Kind::Maybe::Methods

    def self.call
      None()
    end
  end

  class Nothing2
    include Kind::Maybe::Methods

    def call
      None()
    end
  end

  def test_multiple_the_none_method
    assert Nothing1.call.none?
    assert Nothing2.new.call.none?
  end
end
