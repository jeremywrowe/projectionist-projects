require 'test_helper'

class Projectionist::ProjectsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Projectionist::Projects::VERSION
  end
end
