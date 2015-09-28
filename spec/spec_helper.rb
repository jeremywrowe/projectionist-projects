ENV["TEST"] = "true"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

SPEC_ROOT = File.expand_path("..", __FILE__)

require 'simplecov'
SimpleCov.start

require "projectionist/projects"
require "fileutils"

include FileUtils

RSpec.configure do |config|
  config.before(:each, writeable: true) do
    rm_rf   Projectionist::Projects::DOWNLOAD_DIRECTORY
    mkdir_p Projectionist::Projects::DOWNLOAD_DIRECTORY
  end
end
