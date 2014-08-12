require 'spec_helper'

describe GooderData::Project::Report::Series do
  describe ".parse" do
    subject(:parse) { GooderData::Project::Report::Series.parse(JSON.parse(json)) }
    let(:one_series_json) { File.read('spec/fixtures/gooder_data/project/one_series_report.json') }
    let(:multi_series_json) { File.read('spec/fixtures/gooder_data/project/multi_series_report.json') }

    context "when there are only one series" do
      let(:json) { one_series_json }
      let(:series) { parse.first }

      it "should have size one" do
        expect(parse.size).to eq 1
      end

      describe "#name" do
        subject(:name) { series.name }

        it "should have the name of the series" do
          expect(name).to eq "Qtd. Pessoas (Cadastro)"
        end
      end

      describe "#data" do
        subject(:data) { series.data }

        context "when the given x value is present in the series x axis" do
          [
            ['1/2014', '10346'],
            ['2/2014', '14237'],
            ['3/2014', '13973'],
            ['4/2014', '9700'],
            ['5/2014', '15638'],
            ['6/2014', '13025']
          ].each do |x, y|
            it "should return the y value of that point" do
              expect(data[x]).to eq y
            end
          end

        end
      end
    end

    context "when there are multiple series" do
      let(:json) { multi_series_json }
      let(:series) { parse }

      it "should have the correct size of series" do
        expect(parse.size).to eq 6
      end

      describe "#data" do
        subject(:data) { series.first.data }

        context "when the given x value is present in the series x axis" do
          [
            ['Aug 2010', '136'],
            ['Sep 2010', '100'],
            ['Oct 2010', '13'],
            ['Nov 2010', '71'],
            ['Dec 2010', '36'],
            ['Jan 2011', '29'],
            ['Feb 2011', '27'],
            ['Mar 2011', '62'],
            ['Apr 2011', '45'],
            ['May 2011', '76'],
            ['Jun 2011', '84'],
            ['Jul 2011', '124'],
            ['Aug 2011', '134']
          ].each do |x, y|
            it "should return the y value of that point" do
              expect(data[x]).to eq y
            end
          end

        end
      end
    end

  end
end
