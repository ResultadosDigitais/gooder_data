require 'spec_helper'

describe GooderData::Configuration do

  it "raises error when tries to configure inexstant option" do
    expect { GooderData.configuration.merge(inexistant: 'any_value') }.to raise_error GooderData::Configuration::UnknownOptionError
  end

  it "raises error when tries to configure an option with string key" do
    expect { GooderData.configuration.merge({ 'project_id' => 'any_value' }) }.to raise_error GooderData::Configuration::UnknownOptionError
  end

  it "should be able to configure a valid option" do
    expect { GooderData.configuration.merge(project_id: 'any_value') }.not_to raise_error
  end

  it "raises unknown option error when tries to get an inexstant option after merge" do
    expect { GooderData.configuration.merge({})[:inexstant] }.to raise_error GooderData::Configuration::UnknownOptionError
  end

  it "raises unknown option error when tries to get an option with string key after merge" do
    expect { GooderData.configuration.merge({})['project_id'] }.to raise_error GooderData::Configuration::UnknownOptionError
  end

  it "should be able to get a valid option after merge" do
    expect { GooderData.configuration.merge({})[:project_id] }.not_to raise_error
  end

  it "should override the value when a valid option is merged" do
    expect(GooderData.configuration.merge(project_id: 'new value')[:project_id]).to eq 'new value'
  end

  it "should not update global configuration with merge" do
    GooderData.configure do |c|
      c.project_id = 'global value'
    end
    expect(GooderData.configuration.merge(project_id: 'new value')[:project_id]).to eq 'new value'
    expect(GooderData.configuration.project_id).to eq 'global value'
  end

  it "options can be nil" do
    GooderData.configure do |c|
      c.project_id = nil
    end
    expect(GooderData.configuration.merge(project_id: nil)[:project_id]).to be_nil
    expect(GooderData.configuration.project_id).to be_nil
  end

  it "raises required option error when requires an option with nil value" do
    expect { GooderData.configuration.merge(project_id: nil).require(:project_id) }.to raise_error GooderData::Configuration::RequiredOptionError
  end

end
