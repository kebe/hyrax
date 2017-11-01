RSpec.describe Hyrax::LinkedDataAttributesIndexer do
  subject(:solr_document) { service.to_solr }

  let(:user) { create(:user) }
  let(:service) { described_class.new(resource: work) }
  let(:work) { create_for_repository(:work) }
  let(:mpls) { File.open(fixture_path + '/geonames_json_mpls') }

  before do
    stub_request(:get, /2638077/)
      .to_return(status: 404, body: '')

    stub_request(:get, /5037649/)
      .to_return(status: 200, body: mpls)
  end

  context "with one remote resource (based near)" do
    before do
      work.based_near = ['http://sws.geonames.org/5037649/']
    end

    it "indexes id and label" do
      expect(subject.fetch(:based_near_label_tesim)).to eq ["Minneapolis, Minnesota, United States"]
    end
  end

  context "with two remote resources (based near), where one fails to be retrieved" do
    before do
      work.based_near = ['http://sws.geonames.org/5037649/', 'http://sws.geonames.org/2638077/']
    end

    it "indexes id and label" do
      expect(subject.fetch(:based_near_label_tesim)).to eq ["Minneapolis, Minnesota, United States", "http://sws.geonames.org/2638077/"]
    end
  end
end
