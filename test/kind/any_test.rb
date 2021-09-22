require 'test_helper'

class Kind::AnyTest < Minitest::Test
  require 'kind/any'

  def test_the_kind_any_constructor
    [nil, {}, [], 1, '', :s].each do |value|
      assert_raises_with_message(
        Kind::Error,
        "#{value.inspect} expected to be a kind of filled array"
      ) { Kind::Any[value] }
    end

    [nil, {}, [], 1, '', :s].each do |value|
      assert_raises_with_message(
        Kind::Error,
        "#{value.inspect} expected to be a kind of filled array"
      ) { Kind::Any.new(value) }
    end
  end

  Level1 = Kind::Any[:low, :high]
  Level2 = Kind::Any.new(:low, :high)

  Status1 = Kind::Any[%w[open close]]
  Status2 = Kind::Any.new(%w[open close])

  def test_kind_any
    [Level1, Level2].each do |level|
      assert level === :low
      assert level === :high

      refute level === :foo

      assert level[:low] == :low
      assert level[:high] == :high

      assert_raises_with_message(
        Kind::Error,
        ':foo expected to be a kind of Kind::Any[:low, :high]'
      ) { level[:foo] }

      assert (level | Status1) === :low
      assert (level | Status2) === 'close'

      assert level.inspect == 'Kind::Any[:low, :high]'

      assert level.values == [:low, :high]
    end

    [Status1, Status2].each do |status|
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
end
