require 'test_helper'

class KindFunctionalActionTest < Minitest::Test
  require 'kind/functional/action'

  class UserRecord
    attr_reader :name

    def self.create(data)
      new(data)
    end

    def initialize(data)
      name = data[:name]

      @name = name.kind_of?(::String) ? name : ''
    end

    def persisted?
      !name.empty?
    end
  end

  class CreateUser
    include Kind::Functional::Action

    unless ENV.fetch('KIND_BASIC', '').empty?
      respond_to_create = ->(value) { value.respond_to?(:create) }.tap do |kind|
        def kind.name; 'Kind::RespondTo[:create]'; end
      end

      dependency :repository, respond_to_create, default: UserRecord
    else
      dependency :repository, Kind::RespondTo[:create], default: UserRecord
    end

    def call!(arg)
      return Failure(message: 'arg must be a hash') unless arg.kind_of?(Hash)

      user = repository.create(arg)

      user.persisted? ? Success(user: user) : Failure(message: 'user cannot be created')
    end

    kind_functional_action!
  end

  def test_the_kind_action
    result1 = CreateUser.new.call(1)
    assert result1.failed?
    assert result1.value[:message] == 'arg must be a hash'

    # --

    result2 = CreateUser.new.call({})
    assert result2.failed?
    assert result2.value[:message] == 'user cannot be created'

    # --

    result3 = CreateUser.new.call(name: 'foo')
    assert result3.succeeded?
    assert result3.value[:user].persisted?
  end

  class Double
    include Kind::Functional::Action

    def call!(n)
      Success(n * 2)
    end

    kind_functional_action!
  end

  class Triple
    include Kind::Functional::Action

    def call!(number:)
      Success(number * 3)
    end

    kind_functional_action!
  end

  class Sum
    include Kind::Functional::Action

    def call!(*args)
      args.map! { |value| value.kind_of?(Numeric) ? value : 0 }

      Success(args.reduce(:+))
    end

    kind_functional_action!
  end

  def test_that_module_to_proc
    assert [2, 4, 6] == [1, 2, 3].map(&Double.new).map(&:value)

    assert 6 == Triple.new.to_proc[number: 2].value

    assert 6 == Sum.new.to_proc[1, 2, 3].value
  end

  class Add
    include Kind::Functional::Action

    def call!(a, b)
      Success(number(a) + number(b))
    end

    private

      def number(value)
        value.kind_of?(Numeric) ? value : 0
      end

    kind_functional_action!
  end

  def test_the_curry_method
    add = Add.new
    add3 = add.curry[3]

    assert 4 == add3[1].value
  end

  @@contract_error1 =
    begin
      module Foo; include Kind::Functional::Action; end
    rescue => e
      e
    end

  @@contract_error2 =
    begin
      class Foz
        include Kind::Functional::Action

        kind_functional_action!
      end
    rescue => e
      e
    end

  @@contract_error3 =
    begin
      class Biz
        include Kind::Functional::Action

        def call!(_)
        end

        def foo
        end

        kind_functional_action!
      end
    rescue => e
      e
    end

  @@contract_error4 =
    begin
      class Buz
        include Kind::Functional::Action

        def call!()
        end

        kind_functional_action!
      end
    rescue => e
      e
    end

  def test_the_contract_errors
    assert Kind::Error === @@contract_error1
    assert_equal('KindFunctionalActionTest::Foo expected to be a kind of Class', @@contract_error1.message)

    assert Kind::Error === @@contract_error2
    assert_equal('expected KindFunctionalActionTest::Foz to implement `#call!`', @@contract_error2.message)

    assert Kind::Error === @@contract_error3
    assert_equal('KindFunctionalActionTest::Biz can only have `#call!` as its public method', @@contract_error3.message)

    assert ArgumentError === @@contract_error4
    assert_equal('KindFunctionalActionTest::Buz#call! must receive at least one argument', @@contract_error4.message)
  end

  @@wrong_usage_error1 =
    begin
      class Doublex < Double
      end
    rescue => e
      e
    end

  def test_the_wrong_usage_errors
    assert RuntimeError === @@wrong_usage_error1
    assert_equal("KindFunctionalActionTest::Double is a Kind::Functional::Action and it can't be inherited", @@wrong_usage_error1.message)
  end

  def test_the_execution_of_require_function_contract_twice
    assert Double == Double.kind_functional_action!
  end

  class Divide
    include Kind::Functional::Action

    def call!(a, b)
      a / b
    end

    kind_functional_action!
  end

  def test_that_the_call_method_must_return_a_kind_result
    assert_raises_with_message(
      Kind::Error,
      'KindFunctionalActionTest::Divide#call! must return a Kind::Success or Kind::Failure'
    ) { Divide.new.call(2, 2) }
  end

  module Adds
    extend Kind::Functional::Action

    def call!(a, b)
      return Success(a + b) if a.kind_of?(Numeric) && b.kind_of?(Numeric)

      Failure('arguments must be numerics')
    end

    kind_functional_action!
  end

  def test_the_kind_action_in_a_module
    result1 = Adds.(1, 1)

    assert result1.success?
    assert 2 == result1.value

    # --

    result2 = Adds.('1', 2)

    assert result2.failure?
    assert 'arguments must be numerics' == result2.value

    # --

    add3 = Adds.curry[3]

    assert add3.(2).value == 5
    assert add3.('2').value == 'arguments must be numerics'
  end

  @@module_contract_error1 =
    begin
      class Foo2; extend Kind::Functional::Action; end
    rescue => e
      e
    end

  @@module_contract_error2 =
    begin
      module Foz2
        extend Kind::Functional::Action

        kind_functional_action!
      end
    rescue => e
      e
    end

  @@module_contract_error3 =
    begin
      module Biz2
        extend Kind::Functional::Action

        def call!(_)
        end

        def foo
        end

        kind_functional_action!
      end
    rescue => e
      e
    end

  @@module_contract_error4 =
    begin
      module Buz2
        extend Kind::Functional::Action

        def call!()
        end

        kind_functional_action!
      end
    rescue => e
      e
    end

  def test_the_module_contract_errors
    assert Kind::Error === @@module_contract_error1
    assert_equal('KindFunctionalActionTest::Foo2 expected to be a kind of Module', @@module_contract_error1.message)

    assert Kind::Error === @@module_contract_error2
    assert_equal('expected KindFunctionalActionTest::Foz2 to implement `#call!`', @@module_contract_error2.message)

    assert Kind::Error === @@module_contract_error3
    assert_equal('KindFunctionalActionTest::Biz2 can only have `#call!` as its public method', @@module_contract_error3.message)

    assert ArgumentError === @@module_contract_error4
    assert_equal('KindFunctionalActionTest::Buz2#call! must receive at least one argument', @@module_contract_error4.message)
  end

  module Addx
    extend Kind::Functional::Action

    def call!(a, b:)
      return Success(a + b) if a.kind_of?(Numeric) && b.kind_of?(Numeric)

      Failure('arguments must be numerics')
    end

    kind_functional_action!
  end

  def test_the_kind_action_in_a_module_where_its_call_receive_args_and_kargs
    assert 3 == Addx.(1, b: 2).value
  end

  # --

  class User
    attr_reader :id, :name

    def self.find_by(id:)
      new(id, 'John Doe') if id
    end

    def initialize(id, name)
      @id = id
      @name = name
    end

    # def update(params)
    #   Kind::Maybe[params[:name]].then(:strip).presence.on do |result|
    #     result.none { false }
    #     result.some { |name| @name = name and true }
    #   end
    # end

    def update(params)
      name = params[:name]

      return false unless name.kind_of?(String)

      name_normalized = name.strip

      return false if name_normalized.empty?

      @name = name_normalized and true
    end

    def errors
      OpenStruct.new(full_messages: ["Name can't be blank"])
    end
  end

  FindUser = ->(id:) do
    user = User.find_by(id: id)

    return Kind::Success(user: user) if user

    Kind::Failure(message: "user not found")
  end

  module UpdateUser1
    extend Kind::Functional::Action

    def call!(params, input)
      user_params = params.kind_of?(Hash) ? params : {}

      return Failure(message: 'user params is empty') if user_params.empty?

      user = input[:user] if input.respond_to?(:[])

      update(user: user, params: user_params)
    end

    private

      def update(user:, params: user_params)
        return Failure(message: 'user is missing') unless user

        return Success(user: user) if user.update(params)

        Failure(message: user.errors.full_messages.join(', '))
      end

    kind_functional_action!
  end

  def test_the_composition_of_find_user_and_update_user_1
    [
      {},
      {id: 1},
      {id: 1, user: []},
      {id: 1, user: {}},
      {id: 1, user: {name: ''}}
    ].each do |params|
      result =
        FindUser
          .call(id: params[:id])
          .then(&UpdateUser1.curry[params[:user]])

      assert result.failure?
    end

    [
      {id: 1, user: {name: 'Rodrigo Serradura'}}
    ].each do |params|
      result =
        FindUser
          .call(id: params[:id])
          .then(&UpdateUser1.curry[params[:user]])

      assert result.success?
    end
  end

  class UpdateUser2
    include Kind::Functional::Action

    unless ENV.fetch('KIND_BASIC', '').empty?
      dependency(:params, ->(value) { value.nil? || value.kind_of?(Hash) }.tap do |kind|
        def kind.name; '(Hash | nil)'; end
      end)
    else
      dependency :params, Kind::Hash | Kind::Nil
    end

    def call!(input)
      user = input[:user] if input.respond_to?(:[])

      return Failure(message: 'user is missing') unless user
      return Failure(message: 'user params is empty') if !params || params.empty?

      return Success(user: user) if user.update(params)

      Failure(message: user.errors.full_messages.join(', '))
    end

    kind_functional_action!
  end

  def test_the_composition_of_find_user_and_update_user_2
    [
      {},
      {id: 1},
      {id: 1, user: {}},
      {id: 1, user: {name: ''}}
    ].each do |params|
      result =
        FindUser
          .call(id: params[:id])
          .then(&UpdateUser2.new(params: params[:user]))

      assert result.failure?
    end

    [
      {id: 1, user: {name: 'Rodrigo Serradura'}}
    ].each do |params|
      result =
        FindUser
          .call(id: params[:id])
          .then(&UpdateUser2.new(params: params[:user]))

      assert result.success?
    end
  end
end
