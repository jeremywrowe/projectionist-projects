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
    rm_rf Projectionist::Projects::DOWNLOAD_DIRECTORY if File.exist? Projectionist::Projects::DOWNLOAD_DIRECTORY
  end

  config.before(:each, setup_download_dir: true) do
    mkdir_p Projectionist::Projects::DOWNLOAD_DIRECTORY
  end
end

def run_command_with(args)
  command = File.expand_path("../../exe/projection", __FILE__)
  args    = args.join(" ")
  `TEST=true #{command} #{args}`
end

