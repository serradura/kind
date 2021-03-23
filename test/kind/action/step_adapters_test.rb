require 'test_helper'

class KindActionStepAdaptersTest < Minitest::Test
  require 'kind/action'

  DB = []

  class CreateUser
    include Kind::Action

    attribute :name
    attribute :email

    def call!
      Step!(:validate) \
        >> Step(:create) \
        >> Step(:welcome_email)
    end

    private

      def validate
        return Success() if name && email

        Failure(message: 'ops... Name and email must be present!')
      end

      def create
        return Success() if DB.push(attributes)

        Failure(message: 'Panic!!!')
      end

      def welcome_email
        # UserMailer.welcome(email).deliver_later

        Success(message: 'Please, confirm your email.')
      end

    kind_action!
  end

  def test_the_create_user
    DB.clear

    # --

    result1 = CreateUser.(name: nil, email: nil)

    assert result1.failure?
    assert_equal(:error, result1.type)
    assert_equal({message: 'ops... Name and email must be present!'}, result1.value)

    # --

    result2 = CreateUser.(name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com')

    assert result2.success?
    assert_equal(:ok, result2.type)
    assert_equal({message: 'Please, confirm your email.'}, result2.value)

    assert_equal(
      {name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com'},
      DB.last
    )
  end

  class Add
    include Kind::Action

    attribute :a
    attribute :b

    def call!
      Check!(:presence) \
        | Map(:normalize) \
        | Map(:calc)
    end

    private

      def presence
        a && b
      end

      def normalize
        { a: a.to_i, b: b.to_i }
      end

      def calc(numbers)
        { number: numbers[:a] + numbers[:b] }
      end

    kind_action!
  end

  def test_the_addition
    result1 = Add.({})

    assert result1.failure?
    assert_equal(:presence, result1.type)

    assert_equal({}, result1.value)

    # --

    result2 = Add.(a: '1', b: 2)

    assert result2.success?
    assert_equal(:calc, result2.type)
    assert_equal({number: 3}, result2.value)
  end

  class Divide
    include Kind::Action

    attribute :a
    attribute :b

    def call!
      Try!(:calc, catch: ZeroDivisionError)
    end

    private

      def calc
        { number: a / b }
      end

    kind_action!
  end

  class DivideByZero
    include Kind::Action

    attribute :a

    def call!
      Map!(:normalize) \
        | Try(:calc, catch: ZeroDivisionError)
    end

    private

      def normalize
        { a: a.to_i }
      end

      def calc(input)
        { number: input[:a] / 0 }
      end

    kind_action!
  end

  def test_the_division
    result1 = Divide.(a: 4, b: 2)

    assert result1.success?
    assert_equal(:calc, result1.type)
    assert_equal({number: 2}, result1.value)

    # --

    result2 = Divide.(a: 2, b: 0)

    assert result2.failure?
    assert_equal(:calc, result2.type)
    assert_instance_of(ZeroDivisionError, result2.value[:exception])

    # --

    assert_raises(TypeError) { Divide.(a: 4, b: '2') }

    # --

    result3 = DivideByZero.(a: '2')

    assert result3.failure?
    assert_equal(:calc, result3.type)
    assert_instance_of(ZeroDivisionError, result3.value[:exception])
  end

  LOG = []

  class Multiply
    include Kind::Action

    attribute :a
    attribute :b

    def call!
      Check!(:presence) \
        | Step(:do_something) \
        | Tee(:log) \
        | Map(:calc)
    end

    private

      def presence
        a && b
      end

      def do_something
        Success(inspect: [a, b].inspect)
      end

      def log(first_output)
        LOG << first_output[:inspect]
      end

      def calc(first_output)
        { number: a * b }.merge(first_output)
      end

    kind_action!
  end

  def test_the_multiplication
    LOG.clear

    # --

    result = Multiply.(a: 2, b: 2)

    assert result.success?
    assert_equal(:calc, result.type)
    assert_equal({number: 4, inspect: '[2, 2]'}, result.value)

    assert_equal('[2, 2]', LOG.last)
  end

  class Double
    include Kind::Action

    attribute :number

    def call!
      Success(number: number * 2)
    end

    kind_action!
  end

  def test_add_and_double
    result = Add.(a: 1, b: 2).then(Double)

    assert result.success?
    assert_equal(:ok, result.type)
    assert_equal({number: 6}, result.value)
  end
end
