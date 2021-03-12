require 'test_helper'

class Kind::TryTest < Minitest::Test
  require 'kind/try'

  def test_the_calling_of_a_method_if_the_given_object_respond_to_it
    # FACT: the execution works with *args
    assert_equal('foo', Kind::Try.(' foo ', :strip))
    assert_equal(1, Kind::Try.({a: 1}, :[], :a))
    assert_equal(2, Kind::Try.({a: 1}, :fetch, :b, 2))
    assert_nil(Kind::Try.({a: 1}, :[], :b))

    # FACT: the execution works with an array with the args
    assert_equal('foo', Kind::Try.(' foo ', [:strip]))
    assert_equal(1, Kind::Try.({a: 1}, [:[], :a]))
    assert_equal(2, Kind::Try.({a: 1}, [:fetch, :b, 2]))
    assert_nil(Kind::Try.({a: 1}, [:[], :b]))

    # FACT: Returns nil if the object doesn't respond to the method
    assert_nil(Kind::Try.(:symbol, :strip))

    # FACT: Returns nil if the object is nil or Kind::Undefined
    assert_nil(Kind::Try.(nil, :strip))
    assert_nil(Kind::Try.(Kind::Undefined, :strip))

    # FACT: Raises an exception if the method name isn't a string or a symbol
    exception_message =
      RUBY_VERSION < '2.2.0' ? '1 is not a symbol' : '1 is not a symbol nor a string'

    assert_raises_with_message(TypeError, exception_message) { Kind::Try.({a: 1}, 1, :a) }

    assert_raises_with_message(TypeError, exception_message) { Kind::Try.({a: 1}, [1, :a]) }
  end

  def test_the_creation_of_a_lambda_that_knows_how_to_performs_the_try_strategy
    results =
      [
        {},
        {name: 'Foo Bar'},
        {name: 'Rodrigo Serradura'},
      ].map(&Kind::Try[:fetch, :name, 'John Doe'])

    assert_equal(
      ['John Doe', 'Foo Bar', 'Rodrigo Serradura'],
      results
    )
  end

  def test_the_usage_of_a_block_after_try
    assert Kind::Try.({a: 2}, :[], :a) { true }
    assert Kind::Try.({a: 2}, :[], :a) { |number| number * 2 } == 4

    assert Kind::Try.({a: 2}, [:[], :a]) { true }
    assert Kind::Try.({a: 2}, [:[], :a]) { |number| number * 2 } == 4

    assert_nil Kind::Try.({a: 2}, :b, 0) { true }
    assert_nil Kind::Try.({a: 2}, [:b, 0]) { true }
  end

  def test_the_try_presence
    assert Kind::Try.({a: ''}, :[], :a) == ''

    assert_nil Kind::Try.presence({a: ''}, :[], :a)

    # --

    assert Kind::Try.({a: ''}, :[], :a) { true }

    assert Kind::Try.({a: ''}, :[], :a) { |str| str } == ''

    assert_nil Kind::Try.presence({a: ''}, :a) { |str| str }
  end
end
