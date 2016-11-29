require 'spec_helper'

describe GooderData::Project::RawReport do
  let(:project_id) { 'abc' }
  let(:object_id) { 123 }

  subject(:raw_report) { described_class.new(project_id, object_id) }

  describe '#initialize' do
    it { is_expected.to respond_to(:raw_data) }
    it { is_expected.to respond_to(:status) }

    it { expect(raw_report.project_id).to eq project_id }
    it { expect(raw_report.object_id).to eq object_id }
    it { expect(raw_report.status).to eq GooderData::Project::Status::NOT_FETCHED }
  end
end
