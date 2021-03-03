require 'test_helper'

class KindFunctionalTest < Minitest::Test
  require 'kind/functional'

  class Add
    include Kind::Functional

    def call(a, b)
      number(a) + number(b)
    end

    private

      def number(value)
        Kind::Numeric.or(0, value)
      end

    require_functional_contract!
  end

  def test_that_an_instance_behave_like_a_lambda
    add = Add.new

    assert 2 == add.(1, 1)
    assert 4 == add.call(2, 2)
    assert 6 == add[3, 3]
    assert 8 == add.===(4, 4)
    assert 10 == add.yield(5, 5)
  end

  def test_the_curry_method
    add = Add.new
    add3 = add.curry[3]

    assert 4 == add3[1]
  end

  class Double
    include Kind::Functional

    def call(n)
      n * 2
    end

    require_functional_contract!
  end

  class Triple
    include Kind::Functional

    def call(number:)
      number * 3
    end

    require_functional_contract!
  end

  class Sum
    include Kind::Functional

    def call(*args)
      args.map!(&Kind::Numeric.or(0))
      args.reduce(:+)
    end

    require_functional_contract!
  end

  def test_that_module_to_proc
    assert [2, 4, 6] == [1, 2, 3].map(&Double.new)

    assert 6 == Triple.new.to_proc[number: 2]

    assert 6 == Sum.new.to_proc[1, 2, 3]
  end

  @@contract_error1 =
    begin
      module Foo; include Kind::Functional; end
    rescue => e
      e
    end

  @@contract_error2 =
    begin
      class Foz
        include Kind::Functional

        require_functional_contract!
      end
    rescue => e
      e
    end

  @@contract_error3 =
    begin
      class Biz
        include Kind::Functional

        def call(_)
        end

        def foo
        end

        require_functional_contract!
      end
    rescue => e
      e
    end

  @@contract_error4 =
    begin
      class Buz
        include Kind::Functional

        def call()
        end

        require_functional_contract!
      end
    rescue => e
      e
    end

  def test_the_contract_errors
    assert Kind::Error === @@contract_error1
    assert_equal('KindFunctionalTest::Foo expected to be a kind of Class', @@contract_error1.message)

    assert Kind::Error === @@contract_error2
    assert_equal('expected KindFunctionalTest::Foz to implement `#call`', @@contract_error2.message)

    assert Kind::Error === @@contract_error3
    assert_equal('KindFunctionalTest::Biz can only have `#call` as its public method', @@contract_error3.message)

    assert ArgumentError === @@contract_error4
    assert_equal('KindFunctionalTest::Buz#call must receive at least one argument', @@contract_error4.message)
  end

  @@wrong_usage_error1 =
    begin
      class Bar
        extend Kind::Functional

        require_functional_contract!
      end
    rescue => e
      e
    end

  @@wrong_usage_error2 =
    begin
      class Addx < Add
      end
    rescue => e
      e
    end

  def test_the_wrong_usage_errors
    assert RuntimeError === @@wrong_usage_error1
    assert_equal("The Kind::Functional can't be extended, it can be only included.", @@wrong_usage_error1.message)

    assert RuntimeError === @@wrong_usage_error2
    assert_equal("KindFunctionalTest::Add is a Kind::Functional and it can't be inherited by anyone", @@wrong_usage_error2.message)
  end

  def test_the_execution_of_require_function_contract_twice
    assert Add == Add.require_functional_contract!
  end

  class UserRecord
    attr_reader :name

    def self.create(data)
      new(data)
    end

    def initialize(data)
      @name = data[:name]
    end

    def persisted?
      true
    end
  end

  class UserCreator
    include Kind::Functional

    dependency :repository, Kind::RespondTo[:create]

    def call(data)
      return [:error, 'arg must be a hash'] unless Kind::Hash?(data)

      user = repository.create(data)

      user.persisted? ? [:ok, user] : [:error, 'user cannot be created']
    end

    require_functional_contract!
  end

  CreateUser = UserCreator.new(repository: UserRecord)

  def test_the_kind_functional_constructor
    result, value = CreateUser.call(name: 'Foo')

    assert result == :ok

    assert_equal('Foo', value.name)

    assert_instance_of(UserRecord, value)

    # --

    assert_raises_with_message(
      Kind::Error,
      'repository: 1 expected to be a kind of Kind::RespondTo[:create]'
    ) { UserCreator.new(repository: 1) }
  end

  class Addx
    include Kind::Functional

    dependency :increment, Numeric, default: 0

    def call(value)
      Kind::Numeric.or(0, value) + increment
    end

    require_functional_contract!
  end

  def test_a_static_dependency_default
    add0 = Addx.new
    add2 = Addx.new(increment: 2)

    assert 1 == add0.call(1)
    assert 3 == add2.call(1)

    assert 1 == Addx.new(increment: '2').call(1)
  end

  class Addr
    include Kind::Functional

    dependency :increment, Numeric, default: ->{ rand(1..10) }

    def call(value)
      Kind::Numeric.or(0, value) + increment
    end

    require_functional_contract!
  end

  def test_a_proc_with_arity_0_as_a_dependency_default
    add_wtf = Addr.new

    assert add_wtf.call(0) > 0
  end

  class Addh1
    include Kind::Functional

    dependency :increment, Numeric, default: ->(value){ value.to_i }

    def call(value)
      Kind::Numeric.or(0, value) + increment
    end

    require_functional_contract!
  end

  def test_a_proc_with_arity_1_as_a_dependency_default
    add2 = Addh1.new(increment: '2')

    assert 3 == add2.call(1)
  end

  module IncrementHandler
    def self.call(value)
      value.to_i
    end
  end
  class Addh2
    include Kind::Functional

    dependency :increment, Numeric, default: IncrementHandler

    def call(value)
      Kind::Numeric.or(0, value) + increment
    end

    require_functional_contract!
  end

  def test_a_callable_as_a_dependency_default
    add2 = Addh2.new(increment: '2')

    assert 3 == add2.call(1)
  end

  class Addp1
    include Kind::Functional

    dependency :increment, Proc

    def call(value)
      Kind::Numeric.or(0, value) + increment.()
    end

    require_functional_contract!
  end

  def test_a_proc_kind_as_a_dependency
    assert_raises_with_message(
      Kind::Error,
      'increment: nil expected to be a kind of Proc'
    ) { Addp1.new().call(1) }

    assert_raises_with_message(
      Kind::Error,
      'increment: "2" expected to be a kind of Proc'
    ) { Addp1.new(increment: '2') }

    assert 2 == Addp1.new(increment: ->{ 1 }).call(1)
  end

  class Addp2
    include Kind::Functional

    dependency :increment, Proc, default: -> { 0 }

    def call(value)
      Kind::Numeric.or(0, value) + increment.()
    end

    require_functional_contract!
  end

  def test_a_proc_kind_as_a_dependency_which_has_a_default
    assert 0 == Addp2.new(increment: '2').call(0)

    assert 1 == Addp2.new.call(1)

    assert 2 == Addp2.new(increment: ->{ 1 }).call(1)
  end
end
