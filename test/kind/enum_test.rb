require 'test_helper'

class Kind::EnumTest < Minitest::Test
  require 'kind/enum'

  Level1 = Kind::Enum.values([:low, :medium, :high])

  def test_exceptions
    assert_raises_with_message(
      ArgumentError,
      'use an array or hash to define a Kind::Enum'
    ) { Kind::Enum.values(1) }

    assert_raises_with_message(
      ArgumentError,
      'use a string or symbol to define a Kind::Enum item'
    ) { Kind::Enum.values([1]) }
  end

  def test_an_array_of_values_1
    assert Level1.name == 'Kind::EnumTest::Level1'
    assert Level1.is_a?(Module)

    assert_equal([:HIGH, :LOW, :MEDIUM], Level1.constants.sort)

    assert Level1::LOW == 0
    assert Level1::LOW == :low
    assert Level1::LOW == 'low'

    assert_equal(
      '#<Kind::Enum::Item name="LOW" to_s="low" value=0>',
      Level1::LOW.inspect
    )

    [:low, :medium, :high, 'low', 'medium', 'high', 0, 1, 2].each do |key|
      assert Level1 === key
      assert Level1.ref?(key)
    end

    assert_instance_of(Array, Level1.refs)

    assert [:low, :medium, :high, 'low', 'medium', 'high', 0, 1, 2].all? do |value|
      Level1.refs.include?(value)
    end

    [:low, :medium, :high, 'low', 'medium', 'high'].each do |key|
      assert Level1.key?(key)
    end

    [:foo, 'foo', 3].each { |key| refute Level1.ref?(key) }

    [:foo, 'foo', 0, 1, 2].each { |key| refute Level1.key?(key) }

    assert Level1.keys == %w[low medium high]
    assert Level1.values == [0, 1, 2]

    assert Level1.value_at(:low) == 0
    assert Level1.value_at('low') == 0
    assert_nil Level1.value_at(0)
    assert_nil Level1.value_at(:foo)
    assert_nil Level1.value_at('foo')

    assert Level1.key(0) == 'low'
    assert_nil Level1.key(3)
    assert_nil Level1.key(:low)
    assert_nil Level1.key('low')

    assert_equal(
      { 'low' => 0, 'medium' => 1, 'high' => 2 },
      Level1.to_h
    )

    assert Level1.items.all? { |item| item.instance_of?(Kind::Enum::Item) }

    assert Level1.items[0].name == 'LOW'
    assert Level1.items[1].name == 'MEDIUM'
    assert Level1.items[2].name == 'HIGH'

    ['low', :low, 0].each do |value|
      case value
      when Level1::LOW    then assert(1 == 1)
      when Level1::MEDIUM then raise
      when Level1::HIGH   then raise
      end
    end

    ['medium', :medium, 1].each do |value|
      case value
      when Level1::LOW    then raise
      when Level1::MEDIUM then assert(1 == 1)
      when Level1::HIGH   then raise
      end
    end

    ['high', :high, 2].each do |value|
      case value
      when Level1::LOW    then raise
      when Level1::MEDIUM then raise
      when Level1::HIGH   then assert(1 == 1)
      end
    end

    [
      'low'   , :low   , 0,
      'medium', :medium, 1,
      'high'  , :high  , 2
    ].each do |value|
      assert Level1[value] == value
      assert Level1.ref(value) == value
    end

    assert Level1.item(0) == Level1::LOW
    assert Level1.item(:low) == Level1::LOW
    assert Level1.item('low') == Level1::LOW

    assert_nil Level1.ref(3)
    assert_nil Level1.ref(:foo)
    assert_nil Level1.ref('foo')
  end

  module Level2
    include Kind::Enum.values([:low, :medium, :high])
  end

  def test_an_array_of_values_2
    assert Level2.name == 'Kind::EnumTest::Level2'
    assert Level2.is_a?(Module)

    assert Level2::LOW == 0
    assert Level2::LOW == :low
    assert Level2::LOW == 'low'

    assert_equal([:HIGH, :LOW, :MEDIUM], Level2.constants.sort)

    assert_equal(
      '#<Kind::Enum::Item name="LOW" to_s="low" value=0>',
      Level2::LOW.inspect
    )

    [:low, :medium, :high, 'low', 'medium', 'high', 0, 1, 2].each do |key|
      assert Level2 === key
      assert Level2.ref?(key)
    end

    [:low, :medium, :high, 'low', 'medium', 'high'].each do |key|
      assert Level2.key?(key)
    end

    [:foo, 'foo', 3].each { |key| refute Level2.ref?(key) }

    [:foo, 'foo', 0, 1, 2].each { |key| refute Level2.key?(key) }

    assert Level2.keys == %w[low medium high]
    assert Level2.values == [0, 1, 2]

    assert Level2.value_at(:low) == 0
    assert Level2.value_at('low') == 0
    assert_nil Level2.value_at(0)
    assert_nil Level2.value_at(:foo)
    assert_nil Level2.value_at('foo')

    assert Level2.key(0) == 'low'
    assert_nil Level2.key(3)
    assert_nil Level2.key(:low)
    assert_nil Level2.key('low')

    assert_equal(
      { 'low' => 0, 'medium' => 1, 'high' => 2 },
      Level2.to_h
    )

    assert Level2.items.all? { |item| item.instance_of?(Kind::Enum::Item) }

    assert Level2.items[0].name == 'LOW'
    assert Level2.items[1].name == 'MEDIUM'
    assert Level2.items[2].name == 'HIGH'

    ['low', :low, 0].each do |value|
      case value
      when Level2::LOW    then assert(1 == 1)
      when Level2::MEDIUM then raise
      when Level2::HIGH   then raise
      end
    end

    ['medium', :medium, 1].each do |value|
      case value
      when Level2::LOW    then raise
      when Level2::MEDIUM then assert(1 == 1)
      when Level2::HIGH   then raise
      end
    end

    ['high', :high, 2].each do |value|
      case value
      when Level2::LOW    then raise
      when Level2::MEDIUM then raise
      when Level2::HIGH   then assert(1 == 1)
      end
    end

    [
      'low'   , :low   , 0,
      'medium', :medium, 1,
      'high'  , :high  , 2
    ].each do |value|
      assert Level2[value] == value
    end
  end

  module Level3
    include Kind::Enum.from_array([:low, :medium, :high], use_index_as_value: false)
  end

  def test_an_array_of_values_2
    assert Level3.name == 'Kind::EnumTest::Level3'
    assert Level3.is_a?(Module)

    refute Level3::LOW == 0
    assert Level3::LOW == :low
    assert Level3::LOW == 'low'

    assert_equal([:HIGH, :LOW, :MEDIUM], Level3.constants.sort)

    assert_equal(
      '#<Kind::Enum::Item name="LOW" to_s="low" value=:low>',
      Level3::LOW.inspect
    )

    [:low, :medium, :high, 'low', 'medium', 'high'].each do |key|
      assert Level3 === key
      assert Level3.ref?(key)
    end

    [:low, :medium, :high, 'low', 'medium', 'high'].each do |key|
      assert Level3.key?(key)
    end

    [:foo, 'foo', 0, 1, 2].each { |key| refute Level3.ref?(key) }

    [:foo, 'foo'].each { |key| refute Level3.key?(key) }

    assert Level3.keys == %w[low medium high]
    assert Level3.values == %i[low medium high]

    assert Level3.value_at(:low) == :low
    assert Level3.value_at('low') == :low
    assert_nil Level3.value_at(0)
    assert_nil Level3.value_at(:foo)
    assert_nil Level3.value_at('foo')

    assert_nil Level3.key(0)
    assert_nil Level3.key(3)
    assert_nil Level3.key('low')
    assert Level3.key(:low) == 'low'

    assert_equal(
      { 'low' => :low, 'medium' => :medium, 'high' => :high },
      Level3.to_h
    )

    assert Level3.items.all? { |item| item.instance_of?(Kind::Enum::Item) }

    assert Level3.items[0].name == 'LOW'
    assert Level3.items[1].name == 'MEDIUM'
    assert Level3.items[2].name == 'HIGH'

    ['low', :low].each do |value|
      case value
      when Level3::LOW    then assert(1 == 1)
      when Level3::MEDIUM then raise
      when Level3::HIGH   then raise
      end
    end

    ['medium', :medium].each do |value|
      case value
      when Level3::LOW    then raise
      when Level3::MEDIUM then assert(1 == 1)
      when Level3::HIGH   then raise
      end
    end

    ['high', :high].each do |value|
      case value
      when Level3::LOW    then raise
      when Level3::MEDIUM then raise
      when Level3::HIGH   then assert(1 == 1)
      end
    end

    [
      'low'   , :low,
      'medium', :medium,
      'high'  , :high
    ].each do |value|
      assert Level3[value] == value
    end
  end

  Fruits = Kind::Enum.values(
    :banana        => 'bANANA',
    'Orange'       => 'orangE',
    'frutaDoConde' => 'fdc'
  )

  def test_a_hash_to_defin_the_enum_values
    assert Fruits.name == 'Kind::EnumTest::Fruits'
    assert Fruits.is_a?(Module)

    assert Fruits::BANANA == 'banana'
    assert Fruits::BANANA == :banana
    assert Fruits::BANANA == 'bANANA'

    assert_equal([:BANANA, :FRUTA_DO_CONDE, :ORANGE], Fruits.constants.sort)

    assert_equal(
      '#<Kind::Enum::Item name="BANANA" to_s="banana" value="bANANA">',
      Fruits::BANANA.inspect
    )

    [:banana, :Orange, 'banana', 'Orange', 'bANANA', 'orangE'].each do |key|
      assert Fruits === key
      assert Fruits.ref?(key)
    end

    [:banana, :Orange, 'banana', 'Orange'].each do |key|
      assert Fruits.key?(key)
    end

    [:foo, 'foo', 3].each { |key| refute Fruits.ref?(key) }

    [:foo, 'foo', 'bANANA', 'orangE'].each { |key| refute Fruits.key?(key) }

    assert Fruits.keys == %w[banana Orange frutaDoConde]
    assert Fruits.values == %w[bANANA orangE fdc]

    assert Fruits.value_at(:Orange) == 'orangE'
    assert Fruits.value_at('Orange') == 'orangE'
    assert_nil Fruits.value_at(0)
    assert_nil Fruits.value_at(:foo)
    assert_nil Fruits.value_at('foo')

    assert Fruits.key('orangE') == 'Orange'
    assert_nil Fruits.key(3)
    assert_nil Fruits.key(:low)
    assert_nil Fruits.key('low')

    assert_equal(
      { 'banana' => 'bANANA', 'Orange' => 'orangE', 'frutaDoConde' => 'fdc' },
      Fruits.to_h
    )

    assert Fruits.items.all? { |item| item.instance_of?(Kind::Enum::Item) }

    assert Fruits.items[0].name == 'BANANA'
    assert Fruits.items[1].name == 'ORANGE'

    ['banana', :banana, 'bANANA'].each do |value|
      case value
      when Fruits::BANANA then assert(1 == 1)
      when Fruits::ORANGE then raise
      when Fruits::FRUTA_DO_CONDE then raise
      end
    end

    ['Orange', :Orange, 'orangE'].each do |value|
      case value
      when Fruits::BANANA then raise
      when Fruits::ORANGE then assert(1 == 1)
      when Fruits::FRUTA_DO_CONDE then raise
      end
    end

    ['frutaDoConde', :frutaDoConde, 'fdc'].each do |value|
      case value
      when Fruits::BANANA then raise
      when Fruits::ORANGE then raise
      when Fruits::FRUTA_DO_CONDE then assert(1 == 1)
      end
    end

    [
      'banana', :banana, 'bANANA',
      'Orange', :Orange, 'orangE',
      'frutaDoConde', :frutaDoConde, 'fdc'
    ].each do |value|
      assert Fruits[value] == value
      assert Fruits.ref(value) == value
    end

    exception = assert_raises(KeyError) { Fruits[:foo] }
    assert_equal('key or value not found: :foo', exception.message)

    assert Fruits.item(:banana) == Fruits::BANANA
    assert Fruits.item('banana') == Fruits::BANANA
    assert Fruits.item('bANANA') == Fruits::BANANA

    assert_nil Fruits.ref(3)
    assert_nil Fruits.ref(:foo)
    assert_nil Fruits.ref('foo')
  end
end
