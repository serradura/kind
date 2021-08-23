require 'test_helper'

require 'set'
require 'ostruct'

class Kind::PresenceTest < Minitest::Test
  require 'kind/presence'

  class IsBlank
    def initialize(state)
      @state = state
    end

    def blank?
      @state
    end
  end

  def test_the_presence_of_several_objects
    # object#blank?
    assert_nil Kind::Presence.(IsBlank.new(true))
    refute_nil Kind::Presence.(IsBlank.new(false))

    # object == true
    assert Kind::Presence.(true)

    # String === object
    assert_nil Kind::Presence.('')
    assert_nil Kind::Presence.('   ')
    assert_nil Kind::Presence.("\t\n\r")
    assert_nil Kind::Presence.("\u00a0")

    assert 'foo' == Kind::Presence.('foo')

    # object#empty?
    assert_nil Kind::Presence.([])
    assert_nil Kind::Presence.({})
    assert_nil Kind::Presence.(Set.new)

    array = [1, 1]
    hash = {a: 1}
    set = Set.new(array)

    assert array == Kind::Presence.(array)
    assert hash == Kind::Presence.(hash)
    assert set == Kind::Presence.(set)

    # !object
    assert_nil Kind::Presence.(nil)
    assert_nil Kind::Presence.(false)

    assert OpenStruct === Kind::Presence.(OpenStruct.new)
  end

  def test_to_proc
    assert_equal(
      [nil, nil, nil, "1", [2]],
      ['', [], {}, '1', [2]].map(&Kind::Presence)
    )
  end
end
