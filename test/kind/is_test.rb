require 'test_helper'

class Kind::IsTest < Minitest::Test
  def test_the_method_call
    assert Kind::Is.call(String, String)
    assert Kind::Is.call(String, Class.new(String))

    assert_raises_kind_error(given: '""', expected: 'Module') { Kind::Is.('', String) }
  end

  def test_the_kind_is_method
    assert_same(Kind::Is, Kind.is)

    assert Kind.is(String, String)
    assert Kind.is(String, Class.new(String))

    assert_raises_kind_error(given: '""', expected: 'Module') { Kind.is.('', String) }

    # ---

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 1, expected 2)'
    ) { Kind.is(String) }
  end
end
