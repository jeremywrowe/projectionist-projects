require "net/http"
require "csv"

require_relative "projects/version"

module Projectionist
  module Projects
    INDEX_ROOT = "jeremywrowe.github.io"

    def self.fetch_projections
      response = Net::HTTP.get INDEX_ROOT, "/projectionist-projects/index.csv"
      CSV.new(response, headers: true, header_converters: :symbol)
        .map(&:to_hash)
    end
  end
end
