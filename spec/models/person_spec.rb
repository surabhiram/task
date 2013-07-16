require 'spec_helper'

  describe Person do

    before do
      @person = Person.new(name: "Example User", age: 22, mob: "9876543210", gender: "f")
    end
  	
  	describe "name should not be empty" do
  	  before {@person.name = " "}
  	  it { should_not be_valid}	
  	end

  	describe "name should not be too long" do
  		before {@person.name = 'a'*31}
  		it {should_not be_valid}
  	end

  	describe "age is not present" do
  		before {@person.age = nil || 0}
  		it{should_not be_valid}
  	end

  	describe "mobile is not more than 10" do
  		before {@person.mob = "12345678910"}
  		it{should_not be_valid}
  	end

  	describe "mobile not number" do
  		before {@person.mob = "abcdefghij"}
  		it {should_not be_valid}
  	end
  	

  end