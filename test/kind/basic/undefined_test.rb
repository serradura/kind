require 'test_helper'

class Kind::UndefinedTest < Minitest::Test
  def test_inspect
    assert_equal('Kind::Undefined', Kind::Undefined.inspect)
  end

  def test_empty?
    assert Kind::Undefined.empty?
  end

  def test_to_s
    assert_same(Kind::Undefined.inspect, Kind::Undefined.to_s)
  end

  def test_clone
    assert_same(Kind::Undefined, Kind::Undefined.clone)
  end

  def test_dup
    assert_same(Kind::Undefined, Kind::Undefined.dup)
  end

  def test_default
    value = Kind::Undefined
    rand_number = rand

    assert_equal(1, Kind::Undefined.default(value, 1))
    assert_equal(2, Kind::Undefined.default(2, 1))

    assert_equal(rand_number, Kind::Undefined.default(value, rand_number))

    assert_equal(1, Kind::Undefined.default(value, -> { 1 }))
  end
end
