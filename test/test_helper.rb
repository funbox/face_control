if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require 'webmock/minitest'
WebMock.disable_net_connect!

require 'face_control'
require 'stash'
