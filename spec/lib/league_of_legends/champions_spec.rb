require 'spec_helper'

module LeagueOfLegends
  describe Champions do
    subject { Champions.instance }
    
    before(:each) do
      File.stub(:read => 
        '[{"id": 1, "name":"Annie"}]'
      )
    end
    
    it "should throw exception additional instance" do
      expect { 
        Champions.instance.new 
      }.to raise_error(NoMethodError)
    end
    
    it "should initialize champions list" do
      subject.champions.size.should == 1
    end
    
    it "should return name of champion" do
      subject.get_name(1).should == "Annie"
    end
    
    it "should return id of champion" do
      subject.get_id("Annie").should == 1
    end
  end
end