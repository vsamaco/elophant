require 'spec_helper'

module LeagueOfLegends
  describe Items do
    subject { Items.instance }
    
    before(:each) do
      File.stub(:read => '[{"id": "1001","name": "Boots of Speed"}]')
    end
    
    it "should throw exception additional instance" do
      expect { 
        Items.instance.new 
      }.to raise_error(NoMethodError)
    end
    
    it "should initialize items list" do
      subject.items.size.should == 1
    end
    
    it "should return name of item" do
      subject.get_name(1001).should == "Boots of Speed"
    end
    
    it "should return id of item" do
      subject.get_id("Boots of Speed").should == 1001
    end
  end
end