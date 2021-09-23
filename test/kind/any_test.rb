require 'test_helper'

class Kind::AnyTest < Minitest::Test
  require 'kind/any'

  def test_the_kind_any_constructor
    [nil, {}, [], Set.new, 1, '', :s].each do |value|
      assert_raises_with_message(
        Kind::Error,
        "#{value.inspect} expected to be a kind of filled array or set"
      ) { Kind::Any.new(value) }
    end

    [nil, {}, [], Set.new, 1, '', :s].each do |value|
      assert_raises_with_message(
        Kind::Error,
        "#{value.inspect} expected to be a kind of filled array or set"
      ) { Kind::Any[value] }
    end
  end

  Level1 = Kind::Any[Set[:low, :high]]
  Level2 = Kind::Any.new(Set[:low, :high])

  def test_kind_any_with_a_set
    [Level1, Level2].each do |level|
      assert level === :low
      assert level === :high

      refute level === :foo

      assert level[:low] == :low
      assert level[:high] == :high

      assert_raises_with_message(
        Kind::Error,
        ':foo expected to be a kind of Kind::Any{:low, :high}'
      ) { level[:foo] }

      assert (level | Status1) === :low
      assert (level | Status2) === 'close'

      assert level.inspect == 'Kind::Any{:low, :high}'

      assert level.values == Set[:low, :high]
    end
  end

  Status1 = Kind::Any[%w[open close]]
  Status2 = Kind::Any.new(%w[open close])
  Status3 = Kind::Any.new('open', 'close')
  Status4 = Kind::Any['open', 'close']

  def test_kind_any_with_an_array
    [Status1, Status2, Status3, Status4].each do |status|
      assert status === 'open'
      assert status === 'close'

      refute status === 'foo'

      assert status['open'] == 'open'
      assert status['close'] == 'close'

      assert_raises_with_message(
        Kind::Error,
        '"foo" expected to be a kind of Kind::Any["open", "close"]'
      ) { status['foo'] }

      assert (status | Level1) === :low
      assert (status | Level2) === 'close'

      assert status.inspect == 'Kind::Any["open", "close"]'

      assert status.values == %w[open close]
    end
  end

  def test_kind_assert_hash
    assert_raises_with_message(
      Kind::Error,
      'The key :status has an invalid value. Expected: Kind::Any["open", "close"]'
    ) { Kind.assert_hash!({status: 'foo'}, schema: {status: Status1}) }
  end
end
