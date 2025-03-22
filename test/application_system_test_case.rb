require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include SystemTestHelper
  driven_by :selenium, using: ci? ? :headless_chrome : :chrome, screen_size: [ 1400, 1400 ]
end
