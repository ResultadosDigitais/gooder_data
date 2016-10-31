require 'spec_helper'

describe GooderData::Project::QueryAttribute, :vcr do
  subject(:query_attribute) { GooderData::Project::QueryAttribute.new(project_id, attribute_id, options) }
  let(:options) { test_options }
  let(:project_id) { 'ex4mplepr0ject1daxxmbz432w32qzdj' }
  let(:attribute_id) { 1072 }

  describe ".from_json_hash" do
    subject(:from_json_hash) { GooderData::Project::QueryAttribute.from_json_hash(json_hash, options) }
    let(:json_hash) do
      {
        "link" => "/gdc/md/#{ project_id }/obj/#{ attribute_id }",
        "locked" => 0,
        "author" => "/gdc/account/profile/m0ckedpr0f1le0000000000000000003",
        "tags" => "",
        "created" => "2014-04-23 16:58:53",
        "identifier" => "attr.lifecyclestage.lifecyclestage",
        "deprecated" => "0",
        "summary" => "",
        "title" => "Estágio Funil",
        "category" => "attribute",
        "updated" => "2014-06-05 04:05:56",
        "unlisted" => 0,
        "contributor" => "/gdc/account/profile/m0ckedpr0f1le0000000000000000003"
      }
    end

    it "should return an instance of query attribute extracting the project_id from link" do
      expect(from_json_hash.project_id).to eq project_id
    end

    it "should return an instance of query attribute extracting the attribute_id from link" do
      expect(from_json_hash.attribute_id).to eq attribute_id
    end
  end

  describe "#values" do
    subject(:values) { query_attribute.values }

    it "should return all values" do
      expect(values.all).not_to be_empty
    end

    let(:expected_values) { ["Unmarked Opportunity", "Lead",  "Lead Qualificado", "Opportunity",  "Sale",  "Cliente"] }

    it "should return all values" do
      expect(values.map(&:title)).to eq expected_values
    end
  end

end
