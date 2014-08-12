require 'spec_helper'

describe GooderData::IndexedHash do
  subject(:hash) { GooderData::IndexedHash.new(array, key) }
  let(:array) { [Mock.new('a', 10), Mock.new('b', 20), Mock.new('c', 30)] }
  let(:key) { :name }

  it "should be able to get by key" do
    expect(hash['a']).to be array[0]
    expect(hash['b']).to be array[1]
    expect(hash['c']).to be array[2]
  end

  it "should be able to get the first element" do
    expect(hash.first).to be array.first
  end

  it "should be able to get the last element" do
    expect(hash.last).to be array.last
  end

  it "should be able to get the n'th element" do
    expect(hash[1]).to be array[1]
  end

  it "should be able to set the n'th element" do
    new_element = Mock.new('d', 40)
    hash[1] = new_element
    expect(hash[1]).to be new_element
  end

  class Mock
    attr_accessor :name, :value
    def initialize(name, value)
      @name = name
      @value = value
    end
  end

end
