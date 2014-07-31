# Set RAILS_ROOT and load the environment if it's not already loaded.
unless defined?(Rails)
  ENV["RAILS_ROOT"] = File.expand_path("../../", __FILE__)
  require File.expand_path("../../config/environment", __FILE__)
end

ENV["TZ"] = "Canada/Eastern"

Teaspoon.configure do |config|
  config.suite do |suite|
    suite.use_framework :jasmine, "1.3.1"
    suite.matcher = "{test/javascripts}/**/*_test.js"
    suite.helper = "test_helper"
  end
end