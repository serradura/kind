require 'test_helper'

class Kind::StrictDisabledTest < Minitest::Test
  unless ENV.fetch('KIND_STRICT', '').empty?
    require 'kind'
    require 'kind/strict/disabled'

    def test_that_strict_checks_are_disabled
      assert_equal(1, Kind.of(String, 1))
      assert_equal(1, Kind.of_class(1))
      assert_equal(1, Kind.of_module(1))
      assert_equal(1, Kind.of_module_or_class(1))
      assert_equal(1, Kind::String[1])

      assert_nil(Kind::NotNil[nil])
    end
  end
end
