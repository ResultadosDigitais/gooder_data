require 'spec_helper'

describe GooderData::Project::Report::XAxis do
  describe '.parse' do
    subject(:axis) { GooderData::Project::Report::XAxis.parse(JSON.parse(json)) }
    let(:one_series_json) { File.read('spec/fixtures/gooder_data/project/one_series_report.json') }
    let(:multi_series_json) { File.read('spec/fixtures/gooder_data/project/multi_series_report.json') }
    let(:multi_axis_multi_series_json) { File.read('spec/fixtures/gooder_data/project/multi_axis_multi_series_report.json') }

    context 'when there are only one series' do
      let(:json) { one_series_json }

      it 'should have one item for each x value' do
        expect(axis.size).to eq 48
      end

      describe '#data' do
        context 'when the given x value is present in the series x axis' do
          [
            ['1/2014', '10346'],
            ['2/2014', '14237'],
            ['3/2014', '13973'],
            ['4/2014', '9700'],
            ['5/2014', '15638'],
            ['6/2014', '13025']
          ].each do |x, y|
            it 'should return the y value of that point' do
              expect(axis[x]['Qtd. Pessoas (Cadastro)']).to eq y
            end
          end

        end
      end
    end

    context 'when there are multiple series' do
      let(:json) { multi_series_json }

      it 'should have one item for each x value' do
        expect(axis.size).to eq 48
      end

      describe '#data' do
        context 'when the given x value is present in the series x axis' do
          {
            'Mar 2014' => { 'Lead' => '12209', 'Lead Qualificado' => '30', 'Cliente' => '79',   'Venda' => '75',  'Oportunidade Perdida' => '51',  'Oportunidade' => '1167' },
            'Apr 2014' => { 'Lead' => '9719',  'Lead Qualificado' => '55', 'Cliente' => '358',  'Venda' => '135', 'Oportunidade Perdida' => '63',  'Oportunidade' => '1362' },
            'May 2014' => { 'Lead' => '18464', 'Lead Qualificado' => '24', 'Cliente' => '210',  'Venda' => '104', 'Oportunidade Perdida' => '301', 'Oportunidade' => '1445' },
            'Jun 2014' => { 'Lead' => '14938', 'Lead Qualificado' => '11', 'Cliente' => '1443', 'Venda' => '176', 'Oportunidade Perdida' => '222', 'Oportunidade' => '1455' },
            'Jul 2014' => { 'Lead' => '7108',  'Lead Qualificado' => '2',  'Cliente' => '753',  'Venda' => '57',  'Oportunidade Perdida' => '143', 'Oportunidade' => '1244' }
          }.each do |x, series|
            it 'should return the y value of that point' do
              expect(axis[x]).to eq series
            end
          end

        end
      end

    end

    context 'when there are multiple axis multiple series' do
      let(:json) { multi_axis_multi_series_json }

      it 'should have one item for each x value' do
        expect(axis.size).to eq 11
      end

      it 'should return the y value of that point' do
        expect(axis['1/2014']['startups.ig.com.br']).to eq "Visitantes" => "256", "Leads" => "1", "Leads Qualificados" => nil, "Oportunidades" => nil, "Vendas" => nil
      end
    end
  end
end
