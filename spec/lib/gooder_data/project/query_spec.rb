require 'spec_helper'

describe GooderData::Project::Query do
  subject(:query) { GooderData::Project::Query.new(attribute) }

  let(:attribute) { GooderData::JsonHashObject.new(GooderData::Project::QueryAttribute, attribute_json) }
  let(:attribute_json) do
    {
      "link" => "/gdc/md/ex4mplepr0ject1daxxmbz432w32qzdj/obj/1072",
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

  let(:value) { GooderData::JsonHashObject.new(GooderData::Project::QueryValue, { "title"=>"Lead", "uri"=>"/gdc/md/ex4mplepr0ject1daxxmbz432w32qzdj/obj/1072/elements?id=6" }) }
  let(:another_value) { GooderData::JsonHashObject.new(GooderData::Project::QueryValue, { "title"=>"Cliente", "uri"=>"/gdc/md/ex4mplepr0ject1daxxmbz432w32qzdj/obj/1072/elements?id=12940" }) }


  describe "#eq" do
    it "should return the correct query string" do
      expect(query.eq(value)).to eq "[#{ attribute.link }] = [#{ value.uri }]"
    end
  end

  describe "#not_eq" do
    it "should return the correct query string" do
      expect(query.not_eq(value)).to eq "[#{ attribute.link }] <> [#{ value.uri }]"
    end
  end

  describe "#in" do
    it "should return the correct query string" do
      expect(query.in(value, another_value)).to eq "[#{ attribute.link }] IN ([#{ value.uri }], [#{ another_value.uri }])"
    end
  end

  describe "#not_in" do
    it "should return the correct query string" do
      expect(query.not_in(value, another_value)).to eq "[#{ attribute.link }] NOT IN ([#{ value.uri }], [#{ another_value.uri }])"
    end
  end

end
