require "net/http"
require "csv"
require "projectionist/projects/version"

module Projectionist
  module Projects
    INDEX_ROOT = "jeremywrowe.github.io"

    if ENV["TEST"]
      DOWNLOAD_DIRECTORY = File.join(File.expand_path("../../..", __FILE__), "spec", "output")
    else
      DOWNLOAD_DIRECTORY = File.join(ENV["HOME"], ".projection-projects")
    end

    def self.fetch
      csv_contents = Net::HTTP.get INDEX_ROOT, "/projectionist-projects-files/downloads/index.csv"
      CSV.new(csv_contents, headers: true, header_converters: :symbol)
        .map(&:to_hash)
    rescue SocketError
      throw :server_unavailable
    end

    def self.download(project:, ask_to_overwrite: true, stdin: -> { gets })
      normalized_project = "#{project}.projections.json"
      destination_file   = File.join(DOWNLOAD_DIRECTORY, normalized_project)

      if ask_to_overwrite && File.exist?(destination_file)
        print "Overwrite existing file? (y/N) "
        return unless stdin.call.strip.downcase == "y"
      end
      
      json_contents = Net::HTTP.get INDEX_ROOT, "/projectionist-projects-files/downloads/#{normalized_project}"
      File.open(destination_file, "w") do |file|
        file.write json_contents
      end
    rescue SocketError
      throw :server_unavailable
    end
  end
end
