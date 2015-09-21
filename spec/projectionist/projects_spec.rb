require "spec_helper"

describe Projectionist::Projects do
  let(:resp) {
    [ 
      %w( project path                               updated ),
      %w( ember   downloads/ember.projections.json 2015-09-20),
      %w( rails   downloads/rails.projections.json 2015-11-20),
    ]
      .map { |row| row.join(",") }
      .join("\n")
  }

  before do
    allow(Net::HTTP).to receive(:get)
      .with("jeremywrowe.github.io", "/projectionist-projects-files/index.csv")
      .and_return(resp)
  end

  let(:results) { 
    [
      { project: "ember", path: "downloads/ember.projections.json", updated: "2015-09-20" },
      { project: "rails", path: "downloads/rails.projections.json", updated: "2015-11-20" }
    ]
  }

  describe "#fetch_projections" do
    it "fetches the available projection configurations from the remote" do
      expect(described_class.fetch_projections).to match_array results
    end
  end
end
