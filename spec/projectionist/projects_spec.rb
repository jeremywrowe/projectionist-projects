require "spec_helper"

describe Projectionist::Projects do
  let(:resp) {
    [
      %w( project location                         updated ),
      %w( ember   downloads/ember.projections.json 20150920),
      %w( rails   downloads/rails.projections.json 20151120),
    ]
      .map { |row| row.join(",") }
      .join("\n")
  }

  before do
    allow(Net::HTTP).to receive(:get)
      .with("jeremywrowe.github.io", "/projectionist-projects-files/downloads/index.csv")
      .and_return(resp)
  end

  let(:results) {
    [
      { project: "ember", location: "downloads/ember.projections.json", updated: "20150920" },
      { project: "rails", location: "downloads/rails.projections.json", updated: "20151120" }
    ]
  }

  describe "#fetch" do
    it "fetches the available projection configurations from the remote" do
      expect(described_class.fetch).to match_array results
    end

    it "throws a connection error when the remote is down" do
      expect(Net::HTTP).to receive(:get) { raise SocketError, "the system is down.." }

      expect { described_class.fetch }.to raise_error { :server_unavailable }
    end
  end

  describe "#download", writeable: true, setup_download_dir: true do

    let(:ember_file) { File.join(described_class::DOWNLOAD_DIRECTORY, "ember.projections.json") }

    before do
      allow(Net::HTTP).to receive(:get)
        .with("jeremywrowe.github.io", "/projectionist-projects-files/downloads/ember.projections.json")
        .and_return("an ember configuration")
    end

    it "downloads the given projection by project name" do
      stdin_calls = 0
      stdin       = -> { stdin_calls += 1; "no!" }

      described_class.download(project: :ember, stdin: stdin)

      expect(stdin_calls).to be_zero
      expect(File.read(ember_file)).to eql("an ember configuration")
    end

    it "overwrites the existing file if the user allows it" do
      stdin_calls = 0
      stdin       = -> { stdin_calls += 1; "y" }

      File.write(ember_file, "overwrite me")

      expect {
        described_class.download(project: :ember, stdin: stdin)
      }.to output(/overwrite existing/i).to_stdout

      expect(stdin_calls).to be(1)
      expect(File.read(ember_file)).to eql("an ember configuration")
    end
  end
end
