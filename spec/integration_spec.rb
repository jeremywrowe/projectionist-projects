require "spec_helper"

describe "Projectionist - CLI" do
  describe "-s (setup) switch", writable: true do

    it "creates the download directory" do
      run_command_with %w[-s]

      files = Dir[File.join(Projectionist::Projects::DOWNLOAD_DIRECTORY, "*.json")]
      expect(files.count).to be 2
    end

    it "redownloads all files", setup_download_dir: true do
      path = File.join(Projectionist::Projects::DOWNLOAD_DIRECTORY, "ember.projections.json")
      File.open(path, "w") { |file| file.puts "DATA NOT OVERWRITTEN" }

      expect(File.read(path)).to include "DATA NOT OVERWRITTEN"
      run_command_with %w[-s]
      expect(File.read(path)).to_not include "DATA NOT OVERWRITTEN"
    end
  end
end
