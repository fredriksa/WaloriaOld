# Use bundler to load gems
require 'bundler'

# Load gems from Gemfile
Bundler.require

# Load settings for development/production/test environments
require_relative 'config/environment'

# Start the application
run App