require "spec_helper"

describe Projectionist::Projects do
  include Projectionist::Projects

  let(:resp) {
    %w(
      project,path
      ember,projections/ember.projections.json
      rails,projections/rails.projections.json
    ).join("\n")
  }

  it "can fetch the index" do
    expect(Net::HTTP).to receive(:get)
      .with("jeremywrowe.github.io", "/projectionist-projects/index.csv")
      .and_return(resp)

    expect(self).to receive(:parse_index).with(resp)

    fetch_index
  end

  it "parses the index to the correct format" do
    parsed = {
      ember: "projections/ember.projections.json",
      rails: "projections/rails.projections.json"
    }

    expect(parse_index(resp)).to eql parsed
  end
end
