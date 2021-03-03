require 'test_helper'

class KindVersionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kind::VERSION
  end
end
