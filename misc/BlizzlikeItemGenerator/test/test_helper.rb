# Configuration common for all tests (acceptance/models/routes)

# Set the environment to 'test' to use correct settings in config/environment
ENV['RACK_ENV'] = 'test'

# Use bundler to load gems
require 'bundler'

# Load gems from Gemfile
Bundler.require

# Load the environment
require_relative '../config/environment'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in in pagers and files
  config.tty = true

  config.formatter = :documentation #, :progress, :html, :textmate
end