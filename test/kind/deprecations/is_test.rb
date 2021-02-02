require 'test_helper'

class Kind::IsTest < Minitest::Test
  def test_the_method_call
    assert Kind::Is.call(String, String)
    assert Kind::Is.call(String, Class.new(String))

    assert_raises_kind_error(given: '""', expected: 'Module/Class') { Kind::Is.('', String) }

    # ---

    assert Kind::Is.call(KindIsTest::Human1, KindIsTest::Human1)
    assert Kind::Is.call(KindIsTest::Human1, KindIsTest::Person1)
    assert Kind::Is.call(KindIsTest::Human1, KindIsTest::User1)

    # ---

    assert Kind::Is.call(KindIsTest::Human2, KindIsTest::Human2)
    assert Kind::Is.call(KindIsTest::Human2, KindIsTest::Person2)
    assert Kind::Is.call(KindIsTest::Human2, KindIsTest::User2)

    # ---

    assert Kind::Is.call(KindIsTest::Human3, KindIsTest::Human3)
    assert Kind::Is.call(KindIsTest::Human3, KindIsTest::Person3)
    assert Kind::Is.call(KindIsTest::Human3, KindIsTest::User3)
  end

  def test_the_kind_is_method
    assert_same(Kind::Is, Kind.is)

    assert Kind.is(String, String)
    assert Kind.is(String, Class.new(String))

    assert_raises_kind_error(given: '""', expected: 'Module/Class') { Kind.is.('', String) }

    # ---

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 1, expected 2)'
    ) { Kind.is(String) }

    # ---

    assert Kind.is(KindIsTest::Human1, KindIsTest::Human1)
    assert Kind.is(KindIsTest::Human1, KindIsTest::Person1)
    assert Kind.is(KindIsTest::Human1, KindIsTest::User1)

    # --

    assert Kind.is(KindIsTest::Human2, KindIsTest::Human2)
    assert Kind.is(KindIsTest::Human2, KindIsTest::Person2)
    assert Kind.is(KindIsTest::Human2, KindIsTest::User2)

    # --

    assert Kind.is(KindIsTest::Human3, KindIsTest::Human3)
    assert Kind.is(KindIsTest::Human3, KindIsTest::Person3)
    assert Kind.is(KindIsTest::Human3, KindIsTest::User3)
  end
end
