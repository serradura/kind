require 'test_helper'

class Kind::NoteNilTest < Minitest::Test
  def test_that_some_value_isnt_nil
    assert 1 == Kind::NotNil[1]

    assert_raises_with_message(
      Kind::Error,
      'expected to not be nil'
    ) { Kind::NotNil[nil] }
  end
end
