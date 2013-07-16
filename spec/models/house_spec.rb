require 'spec_helper'

describe House do
  
  before do
      @house = House.new(address: "RT nagar, bangalore-32", num_of_ppl: "4")
    end 
  subject { @house }

  it{ should be_valid }

  describe "address should not be empty" do
  	before{ @house.address = " " }
    it { should_not be_valid}
  end

  describe "num_of_ppl should not be empty" do
  	before{ @house.num_of_ppl = nil}
  	it{ should_not be_valid}
  end

  describe "num_of_ppl must not be negative" do
  	before{ @house.num_of_ppl = "-1" }
  	it{ should_not be_valid}
  end

  describe "num_of_ppl can be zero" do
  	before{ @house.num_of_ppl = "0" }
  	it{ should be_valid } 
  end

end
