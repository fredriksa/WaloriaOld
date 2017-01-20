# Configuration for route tests (rake test:routes)

require_relative '../test_helper'
require 'rack/test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    @app ||= App.new
  end

end

RSpec.configure { |c| c.include RSpecMixin }
