require 'test_helper'

class Kind::MaybeTest < Minitest::Test
  def test_maybe_constructor
    optional = Kind::Maybe.new(0)

    assert_equal(0, Kind::Maybe.new(optional).value)
  end

  def test_maybe_result
    object = Object.new

    maybe_result = Kind::Maybe::Result.new(object)

    assert_same(object, maybe_result.value)

    assert_raises(NotImplementedError) { maybe_result.none? }
    assert_raises(NotImplementedError) { maybe_result.some? }
    assert_raises(NotImplementedError) { maybe_result.map { 0 } }
    assert_raises(NotImplementedError) { maybe_result.map! { 0 } }
    assert_raises(NotImplementedError) { maybe_result.then { 0 } }
    assert_raises(NotImplementedError) { maybe_result.then! { 0 } }
    assert_raises(NotImplementedError) { maybe_result.check { true } }
    assert_raises(NotImplementedError) { maybe_result.try(:anything) }
    assert_raises(NotImplementedError) { maybe_result.try!(:anything) }
    assert_raises(NotImplementedError) { maybe_result.try { |value| value.anything } }
    assert_raises(NotImplementedError) { maybe_result.try! { |value| value.anything } }
    assert_raises(NotImplementedError) { maybe_result.value_or(2) }
    assert_raises(NotImplementedError) { maybe_result.value_or { 3 } }
    assert_raises(NotImplementedError) { maybe_result.dig(:any, :thing) }
    assert_raises(NotImplementedError) { maybe_result.presence }
  end

  def test_maybe_some
    assert_predicate(Kind::Maybe.new(2), :some?)

    refute_predicate(Kind::Maybe.new(nil), :some?)
    refute_predicate(Kind::Maybe.new(Kind::Undefined), :some?)
  end

  def test_maybe_none
    assert_predicate(Kind::Maybe.new(nil), :none?)
    assert_predicate(Kind::Maybe.new(Kind::Undefined), :none?)

    refute_predicate(Kind::Maybe.new(1), :none?)
  end

  def test_maybe_value
    optional1 = Kind::Maybe.new(2)

    assert_equal(2, optional1.value)

    # ---

    optional2 = Kind::Maybe.new(nil)

    assert_nil(optional2.value)

    # ---

    optional3 = Kind::Maybe.new(Kind::Undefined)

    assert_equal(Kind::Undefined, optional3.value)
  end

  def test_maybe_value_or_default
    assert_nil(Kind::Maybe[nil].value_or(nil))

    # ---

    optional1 = Kind::Maybe.new(2)

    assert_equal(2, optional1.value_or(0))

    assert_equal(2, optional1.value_or { 0 })

    # ---

    optional2 = Kind::Maybe.new(nil)

    assert_equal(0, optional2.value_or(0))

    assert_equal(1, optional2.value_or { 1 })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { optional2.value_or }

    # ---

    optional3 = Kind::Maybe.new(Kind::Undefined)

    assert_equal(1, optional3.value_or(1))

    assert_equal(0, optional3.value_or{ 0 })

    assert_raises_with_message(
      ArgumentError,
      'the default value must be defined as an argument or block'
    ) { optional3.value_or }
  end

  def test_map_when_maybe_is_none
    optional1 = Kind::Maybe.new(2)
    optional2 = optional1.map(&:to_s)
    optional3 = optional2.map { |value| value * 2 }

    assert_equal('2', optional2.value)
    assert_equal('22', optional3.value)

    assert_predicate(optional2, :some?)
    assert_predicate(optional3, :some?)

    refute_predicate(optional2, :none?)
    refute_predicate(optional3, :none?)

    refute_same(optional2, optional3)
  end

  def test_map_returning_a_nil_value
    optional1 = Kind::Maybe.new(2)
    optional2 = optional1.map { nil }
    optional3 = optional2.map { |value| value * 2 }

    assert_equal(2, optional1.value)

    assert_same(optional2, optional3)

    assert_nil(optional2.value)
    assert_nil(optional3.value)

    assert_predicate(optional2, :none?)
    assert_predicate(optional3, :none?)
  end

  def test_map_returning_an_undefined_value
    optional1 = Kind::Maybe.new(3)
    optional2 = optional1.map { Kind::Undefined }
    optional3 = optional2.map { |value| value * 3 }

    assert_equal(3, optional1.value)

    assert_same(optional2, optional3)

    assert_equal(Kind::Undefined, optional2.value)
    assert_equal(Kind::Undefined, optional3.value)

    assert_predicate(optional2, :none?)
    assert_predicate(optional3, :none?)
  end

  def test_the_constructor_alias
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe[1])

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil])
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined])
  end

  def test_then_as_a_map_alias
    result1 =
      Kind::Maybe[5]
        .then { |value| value * 5 }
        .then { |value| value + 17 }
        .value_or(0)

    assert_equal(42, result1)

    # ---

    result2 =
      Kind::Maybe[5]
        .then { nil }
        .value_or { 1 }

    assert_equal(1, result2)

    # ---

    result3 =
      Kind::Maybe[5]
        .then { Kind::Undefined }
        .value_or(-2)

    assert_equal(-2, result3)
  end

  def test_the_try_method_without_bang
    assert_raises_with_message(Kind::Error, '"upcase" expected to be a kind of Symbol') do
      Kind::Maybe['foo'].try('upcase')
    end

    # ---

    assert_equal('FOO', Kind::Maybe['foo'].try(:upcase).value)
    assert_equal('FOO', Kind::Maybe['foo'].try { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::Some, Kind::Maybe['foo'].try(:upcase))
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe['foo'].try { |value| value.upcase })

    # -

    hash = {a: 1}

    assert_nil(Kind::Maybe[nil].try(:upcase).value)
    assert_nil(Kind::Maybe[hash].try(:upcase).value)
    assert_nil(Kind::Maybe[nil].try(:[], :b).value)
    assert_nil(Kind::Maybe[hash].try(:[], :b).value)

    assert_equal(1, Kind::Maybe[hash].try(:[], :a).value)
    assert_equal(0, Kind::Maybe[hash].try(:fetch, :b, 0).value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[hash].try(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try(:[], :b))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[hash].try(:[], :b))

    assert_instance_of(Kind::Maybe::Some,Kind::Maybe[hash].try(:[], :a))
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe[hash].try(:fetch, :b, 0))

    # ---

    assert_nil(Kind::Maybe[nil].try(:upcase).value)
    assert_nil(Kind::Maybe[nil].try { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try { |value| value.upcase })

    # -

    assert_kind_undefined(Kind::Maybe[Kind::Undefined].try(:upcase).value)
    assert_kind_undefined(Kind::Maybe[Kind::Undefined].try { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined].try(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined].try { |value| value.upcase })
  end

  def test_the_dig_method
    [nil, 1, '', /x/].each do |data|
      assert_nil(Kind::Maybe[data].dig(:foo).value)
      assert_nil(Kind::Maybe[data].dig(:foom, :bar).value)
    end

    # ---

    a = [1, 2, 3]

    assert_equal(1, Kind::Maybe[a].dig(0).value)
    assert_equal(2, Kind::Maybe[a].dig(1).value)
    assert_equal(3, Kind::Maybe[a].dig(2).value)
    assert_equal(3, Kind::Maybe[a].dig(-1).value)

    assert_nil(Kind::Maybe[a].dig(3).value)
    assert_nil(Kind::Maybe[a].dig('foo').value)
    assert_nil(Kind::Maybe[a].dig(:foo, 'bar').value)
    assert_nil(Kind::Maybe[a].dig(:foo, :bar, 'baz').value)

    # ---

    h = { foo: {bar: {baz: 1}}}

    assert_equal({bar: {baz: 1}}, Kind::Maybe[h].dig(:foo).value)
    assert_equal({baz: 1}, Kind::Maybe[h].dig(:foo, :bar).value)
    assert_equal(1, Kind::Maybe[h].dig(:foo, :bar, :baz).value)

    assert_nil(Kind::Maybe[h].dig('foo').value)
    assert_nil(Kind::Maybe[h].dig(:foo, 'bar').value)
    assert_nil(Kind::Maybe[h].dig(:foo, :bar, 'baz').value)

    # --

    g = { 'foo' => [10, 11, 12] }

    assert_equal([10, 11, 12], Kind::Maybe[g].dig('foo').value)
    assert_equal(10, Kind::Maybe[g].dig('foo', 0).value)
    assert_equal(11, Kind::Maybe[g].dig('foo', 1).value)
    assert_equal(12, Kind::Maybe[g].dig('foo', 2).value)
    assert_equal(12, Kind::Maybe[g].dig('foo', -1).value)

    assert_nil(Kind::Maybe[g].dig(:foo).value)
    assert_nil(Kind::Maybe[g].dig(:foo, 0).value)

    # --

    i = { foo: [{'bar' => [1, 2]}, {baz: [3, 4]}] }

    assert_equal(1, Kind::Maybe[i].dig(:foo, 0, 'bar', 0).value)
    assert_equal(2, Kind::Maybe[i].dig(:foo, 0, 'bar', 1).value)
    assert_equal(2, Kind::Maybe[i].dig(:foo, 0, 'bar', -1).value)

    assert_nil(Kind::Maybe[i].dig(:foo, 0, 'bar', 2).value)

    assert_equal(3, Kind::Maybe[i].dig(:foo, 1, :baz, 0).value)
    assert_equal(4, Kind::Maybe[i].dig(:foo, 1, :baz, 1).value)
    assert_equal(4, Kind::Maybe[i].dig(:foo, 1, :baz, -1).value)

    assert_nil(Kind::Maybe[i].dig(:foo, 0, :baz, 2).value)

    # --

    s = Struct.new(:a, :b).new(101, 102)
    o = OpenStruct.new(c: 103, d: 104)
    b = { struct: s, ostruct: o, data: [s, o]}

    assert_equal(101, Kind::Maybe[s].dig(:a).value)
    assert_equal(102, Kind::Maybe[b].dig(:struct, :b).value)
    assert_equal(102, Kind::Maybe[b].dig(:data, 0, :b).value)
    assert_equal(102, Kind::Maybe[b].dig(:data, 0, 'b').value)

    assert_equal(103, Kind::Maybe[o].dig(:c).value)
    assert_equal(104, Kind::Maybe[b].dig(:ostruct, :d).value)
    assert_equal(104, Kind::Maybe[b].dig(:data, 1, :d).value)
    assert_equal(104, Kind::Maybe[b].dig(:data, 1, 'd').value)

    assert_nil(Kind::Maybe[s].dig(:f).value)
    assert_nil(Kind::Maybe[o].dig(:f).value)
    assert_nil(Kind::Maybe[b].dig(:struct, :f).value)
    assert_nil(Kind::Maybe[b].dig(:ostruct, :f).value)
    assert_nil(Kind::Maybe[b].dig(:data, 0, :f).value)
    assert_nil(Kind::Maybe[b].dig(:data, 1, :f).value)
  end

  def test_the_try_method_with_bang
    assert_raises_with_message(Kind::Error, '"upcase" expected to be a kind of Symbol') do
      Kind::Maybe['foo'].try!('upcase')
    end

    # ---

    assert_equal('FOO', Kind::Maybe['foo'].try!(:upcase).value)
    assert_equal('FOO', Kind::Maybe['foo'].try! { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::Some, Kind::Maybe['foo'].try!(:upcase))
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe['foo'].try! { |value| value.upcase })

    # -

    hash = {a: 1}

    assert_raises(NoMethodError) { Kind::Maybe[hash].try!(:upcase) }

    assert_nil(Kind::Maybe[nil].try!(:[], :b).value)
    assert_nil(Kind::Maybe[hash].try!(:[], :b).value)

    assert_equal(1, Kind::Maybe[hash].try!(:[], :a).value)
    assert_equal(0, Kind::Maybe[hash].try!(:fetch, :b, 0).value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try!(:[], :b))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[hash].try!(:[], :b))

    assert_instance_of(Kind::Maybe::Some,Kind::Maybe[hash].try!(:[], :a))
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe[hash].try!(:fetch, :b, 0))

    # ---

    assert_nil(Kind::Maybe[nil].try!(:upcase).value)
    assert_nil(Kind::Maybe[nil].try! { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try!(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[nil].try! { |value| value.upcase })

    # -

    assert_kind_undefined(Kind::Maybe[Kind::Undefined].try!(:upcase).value)
    assert_kind_undefined(Kind::Maybe[Kind::Undefined].try! { |value| value.upcase }.value)

    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined].try!(:upcase))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe[Kind::Undefined].try! { |value| value.upcase })

    # -

    assert_raises_with_message(
      ArgumentError,
      'method name or a block must be present',
    ) { Kind::Maybe[''].try! }
  end

  def test_that_optional_is_a_maybe_alias
    assert_equal(Kind::Maybe, Kind::Optional)

    # ---

    result1 =
      Kind::Optional
        .new(5)
        .map { |value| value * 5 }
        .map { |value| value - 10 }
        .value_or(0)

    assert_equal(15, result1)

    # ---

    result2 =
      Kind::Optional[5]
        .then { |value| value * 5 }
        .then { |value| value + 10 }
        .value_or { 0 }

    assert_equal(35, result2)
  end

  def test_the_kind_none_method
    [Kind.None, Kind::None].each do |kind_none|
      assert_instance_of(Kind::Maybe::None, kind_none)

      assert_nil(kind_none.value)
    end

    assert_same(Kind::None, Kind.None)

    # --

    assert_raises_with_message(ArgumentError, 'wrong number of arguments (given 1, expected 0)') do
      Kind::None(nil)
    end
  end

  def test_the_kind_some_method
    kind_some1 = Kind.Some(1)
    kind_some2 = Kind::Some(1)

    [kind_some1, kind_some2].each do |kind_some|
      assert_instance_of(Kind::Maybe::Some, kind_some)

      assert_equal(1, kind_some.value)
    end

    refute_same(kind_some1, kind_some2)

    # --

    assert_raises_with_message(ArgumentError, 'wrong number of arguments (given 0, expected 1)') do
      Kind::Some()
    end

    # --

    [nil, Kind::Undefined].each do |value|
      assert_raises_with_message(ArgumentError, "value can't be nil or Kind::Undefined") do
        Kind::Some(value)
      end
    end
  end

  Add_A = -> params do
    a, b = Kind::Hash.value_or_empty(params).values_at(:a, :b)

    a + b if Kind::Numeric?(a, b)
  end

  Add_B = -> params do
    a, b = Kind::Hash.value_or_empty(params).values_at(:a, :b)

    return Kind::None unless Kind::Numeric?(a, b)

    Kind::Some(a + b)
  end

  Double_A = -> value {value * 2 if Kind::Numeric?(value) }

  Double_B = -> value {Kind::Numeric?(value) ? Kind::Some(value * 2) : Kind::None }

  def test_the_maybe_objects_in_a_chain_of_mappings
    assert_equal(3, Kind::Maybe.new(a: 1, b: 2).then(&Add_A).value_or(0))
    assert_equal(6, Kind::Maybe.new(a: 1, b: 2).then(&Add_A).then(&Double_B).value_or(0))

    [ [], {}, nil ].each do |value|
      assert_equal(0, Kind::Maybe.new(value).then(&Add_A).value_or(0))
      assert_equal(0, Kind::Maybe.new(value).then(&Add_A).then(&Double_B).value_or(0))
    end

    # --

    assert_equal(3, Kind::Maybe.new(a: 1, b: 2).then(&Add_B).value_or(0))
    assert_equal(6, Kind::Maybe.new(a: 1, b: 2).then(&Add_B).then(&Double_A).value_or(0))

    [ [], {}, nil ].each do |value|
      assert_equal(0, Kind::Maybe.new(value).then(&Add_B).value_or(0))
      assert_equal(0, Kind::Maybe.new(value).then(&Add_B).then(&Double_B).value_or(0))
    end
  end

  def test_the_typed_maybe
    assert_predicate(Kind::Maybe(Hash)[''], :none?)
    assert_predicate(Kind::Maybe(Hash).new([]), :none?)

    assert_predicate(Kind::Maybe(Hash)[{}], :some?)
    assert_predicate(Kind::Maybe(Hash)[Kind::Some({})], :some?)
    assert_predicate(Kind::Maybe(Hash).new({}), :some?)
    assert_predicate(Kind::Maybe(Hash).new(Kind::Some({})), :some?)

    # ---

    assert_predicate(Kind::Optional(Hash)[''], :none?)
    assert_predicate(Kind::Optional(Hash).new([]), :none?)

    assert_predicate(Kind::Optional(Hash)[{}], :some?)
    assert_predicate(Kind::Optional(Hash)[Kind::Some({})], :some?)
    assert_predicate(Kind::Optional(Hash).new({}), :some?)
    assert_predicate(Kind::Optional(Hash).new(Kind::Some({})), :some?)
  end

  def test_the_wrap_method
    assert_instance_of(Kind::Maybe::Some, Kind::Maybe.wrap(1))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe.wrap(nil))
    assert_instance_of(Kind::Maybe::None, Kind::Maybe.wrap(Kind::Undefined))

    division1 = Kind::Maybe.wrap { 4 / 2 }
    assert_predicate(division1, :some?)
    assert_equal(2, division1.value)

    division2 = Kind::Maybe.wrap(10) { |n| n / 2 }
    assert_predicate(division2, :some?)
    assert_equal(5, division2.value)

    exception1 = Kind::Maybe.wrap { 2 / 0 }
    assert_predicate(exception1, :none?)
    assert_instance_of(ZeroDivisionError, exception1.value)

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 0, expected 1)'
    ) { Kind::Maybe.wrap }

    # --

    assert_predicate(Kind::Maybe(Hash).wrap(''), :none?)
    assert_predicate(Kind::Maybe(Hash).wrap({}), :some?)

    assert_predicate(Kind::Optional(Hash).wrap(''), :none?)
    assert_predicate(Kind::Optional(Hash).wrap({}), :some?)
    assert_predicate(Kind::Optional(Hash).wrap(Kind::Some({})), :some?)

    assert_predicate(Kind::Optional(Hash).wrap { Kind::Some({}) }, :some?)

    exception2 = Kind::Maybe(Numeric).wrap { 3 / 0 }
    assert_predicate(exception2, :none?)
    assert_instance_of(ZeroDivisionError, exception2.value)

    division3 = Kind::Maybe(Numeric).wrap { 6 / 2 }
    assert_predicate(division3, :some?)
    assert_equal(3, division3.value)

    division4 = Kind::Maybe(Numeric).wrap(8) { |n| n / 2 }
    assert_predicate(division4, :some?)
    assert_equal(4, division4.value)

    assert_raises_with_message(
      ArgumentError,
      'wrong number of arguments (given 0, expected 1)'
    ) { Kind::Maybe(Numeric).wrap }
  end

  def test_the_presence_method
    str = Kind::Maybe['  ']
    str_presence = str.presence

    assert str.some?
    assert str_presence.none?
    assert_nil(str_presence.value)

    # --

    assert Kind::Maybe[' 2 '].presence.some?

    # --

    nil_presence = Kind::Maybe[nil].presence
    undefined_presence = Kind::Maybe[Kind::Undefined].presence

    assert_predicate(nil_presence, :none?)
    assert_nil(nil_presence.value)

    assert_predicate(undefined_presence, :none?)
    assert_kind_undefined(undefined_presence.value)
  end

  def test_that_exception_values_are_resolved_as_none
    maybe1 = Kind::Maybe.new(0).map do |value|
      begin
        2 / value
      rescue => exception
        exception
      end
    end

    maybe2 = Kind::Maybe.new(0).map! do |value|
      begin
        2 / value
      rescue => exception
        exception
      end
    end

    maybe3 = Kind::Maybe.new(0).then do |value|
      begin
        2 / value
      rescue => exception
        exception
      end
    end

    maybe4 = Kind::Maybe.new(0).then! do |value|
      begin
        2 / value
      rescue => exception
        exception
      end
    end

    maybe5 = Kind::Maybe.new(0).map { |value| 3 / value }

    maybe6 = Kind::Maybe.new(0).then { |value| 3 / value }

    [maybe1, maybe2, maybe3, maybe4, maybe5, maybe6].each do |maybe|
      assert_predicate(maybe, :none?)
      assert_instance_of(ZeroDivisionError, maybe.value)
    end
  end

  def test_that_exceptions_will_leak_on_the_bang_map_or_then_methods
    assert_raises(ZeroDivisionError) do
      Kind::Maybe.new(0).map! { |value| 2 / value }
    end

    assert_raises(ZeroDivisionError) do
      Kind::Maybe.new(0).then! { |value| 2 / value }
    end
  end

  def test_the_check_method
    person_name = ->(params) do
      Kind::Maybe(Hash)
        .wrap(params)
        .then  { |hash| hash.values_at(:first_name, :last_name) }
        .then  { |names| names.map(&Kind::Presence).tap(&:compact!) }
        .check { |names| names.size == 2 }
        .then  { |(first_name, last_name)| "#{first_name} #{last_name}" }
        .value_or { 'John Doe' }
    end

    assert 'John Doe' == person_name.('')
    assert 'John Doe' == person_name.(nil)
    assert 'John Doe' == person_name.(last_name: 'Serradura')
    assert 'John Doe' == person_name.(first_name: 'Rodrigo')

    assert 'Rodrigo Serradura' == person_name.(first_name: 'Rodrigo', last_name: 'Serradura')

    # --

    Kind::Maybe(Array).wrap([1]).check(&:empty?).none?
  end

  def test_that_the_wrap_method_of_a_typed_maybe_verifies_if_the_block_arg_has_the_right_kind
    assert_nil(Kind::Maybe(Numeric).wrap('2') { |number| number / 0 }.value)

    assert_instance_of(
      ZeroDivisionError,
      Kind::Maybe(Numeric).wrap(2) { |number| number / 0 }.value
    )
  end
end
