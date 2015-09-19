require "net/http"
require "csv"
require "byebug"

require_relative "projects/version"

module Projectionist
  module Projects
    INDEX_ROOT = "jeremywrowe.github.io"

    def fetch_index
      resp = Net::HTTP.get INDEX_ROOT, "/projectionist-projects/index.csv"
      parse_index(resp)
    end

    def parse_index(index)
      csv = CSV.new(index, headers: true, header_converters: :symbol)
      csv.to_a.map do |row|
        { row[0].to_sym => row[1] } # row = ["ember", "path/to/projection"]
      end.reduce(&:merge)
    end

  end
end
