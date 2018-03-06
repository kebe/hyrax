RSpec.describe Hyrax::Admin::UserActivityPresenter do
  let(:instance) { described_class.new }

  describe "#to_json" do
    subject { instance.to_json }

    let(:users) do
      instance_double(Hyrax::Statistics::Users::OverTime,
                      points: [['2017-02-16', '12']])
    end

    before do
      allow(Hyrax::Statistics::Users::OverTime).to receive(:new).and_return(users)
    end

    it "returns points" do
      expect(subject).to eq '[{"name":"New Visitors","data":[["2017-02-16","12"]]},{"name":"Returning Visitors","data":[["2017-02-16",null]]}]'
    end
  end
end
