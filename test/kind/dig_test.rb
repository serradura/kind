require 'test_helper'

class Kind::DigTest < Minitest::Test
  class Person
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

  def test_the_extraction_of_values_from_a_sequence_of_objects
    s = Struct.new(:a, :b).new(101, 102)
    o = OpenStruct.new(c: 103, d: 104)
    d = { struct: s, ostruct: o, data: [s, o]}

    assert 101 == Kind::Dig.(s, [:a])
    assert 103 == Kind::Dig.(o, [:c])

    assert 102 == Kind::Dig.(d, [:struct, :b])
    assert 102 == Kind::Dig.(d, [:data, 0, :b])
    assert 102 == Kind::Dig.(d, [:data, 0, 'b'])

    assert 104 == Kind::Dig.(d, [:ostruct, :d])
    assert 104 == Kind::Dig.(d, [:data, 1, :d])
    assert 104 == Kind::Dig.(d, [:data, 1, 'd'])

    assert_nil Kind::Dig.(d, [:struct, :f])
    assert_nil Kind::Dig.(d, [:ostruct, :f])
    assert_nil Kind::Dig.(d, [:data, 0, :f])
    assert_nil Kind::Dig.(d, [:data, 1, :f])

    # FACT: the extraction path must be defined as an array
    assert_nil Kind::Dig.(s, :a)

    # FACT: the extraction args of a Struct must respond to :to_int or :to_sym
    assert_nil Kind::Dig.(s, [{}])
    refute_nil Kind::Dig.(s, [:a])

    # FACT: the extraction args of an OpenStruct must respond to :to_sym
    assert_nil Kind::Dig.(o, [{}])
    refute_nil Kind::Dig.(o, [:c])

    # FACT: can extract args from regular objects (via repond_to? + public_send)
    person = Person.new('Rodrigo')

    assert 'Rodrigo' == Kind::Dig.(person, [:name])

    assert 'Rodrigo' == Kind::Dig.({people: [person]}, [:people, 0, :name])
  end
end
