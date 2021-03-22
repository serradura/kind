# frozen_string_literal: true

module StepAdapterAssertions
  def assert_create_user(create_user, db)
    db.clear

    # --

    result1 = create_user.(name: nil, email: nil)

    assert result1.failure?
    assert_equal(:error, result1.type)
    assert_equal('ops... Name and email must be present!', result1.value)

    # --

    result2 = create_user.(name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com')

    assert result2.success?
    assert_equal(:ok, result2.type)
    assert_equal('Please, confirm your email.', result2.value)

    assert_equal(
      {name: 'Rodrigo', email: 'rodrigo.serradura@gmail.com'},
      db.last
    )
  end

  def assert_addition(add)
    result1 = add.([1, 2])

    assert result1.failure?
    assert_equal(:presence, result1.type)
    assert_equal([1, 2], result1.value)

    # --

    result2 = add.(a: '1', b: 2)

    assert result2.success?
    assert_equal(:calc, result2.type)
    assert_equal(3, result2.value)
  end

  def assert_division(divide)
    result1 = divide.(a: 4, b: 2)

    assert result1.success?
    assert_equal(:calc, result1.type)
    assert_equal(2, result1.value)

    # --

    result2 = divide.(a: 2, b: 0)

    assert result2.failure?
    assert_equal(:calc, result2.type)
    assert_instance_of(ZeroDivisionError, result2.value)

    # --

    assert_raises(TypeError) { divide.(a: 4, b: '2') }
  end

  def assert_multiplication(multiply, log)
    log.clear

    # --

    result = multiply.(a: 2, b: 2)

    assert result.success?
    assert_equal(:calc, result.type)
    assert_equal(4, result.value)

    assert_equal('[2, 2]', log.last)
  end

  def assert_add_and_double(add, double)
    result = add.(a: 1, b: 2).then(double)

    assert result.success?
    assert_equal(:ok, result.type)
    assert_equal(6, result.value)
  end
end

