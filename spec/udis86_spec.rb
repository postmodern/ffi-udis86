require 'udis86/version'

require 'spec_helper'

describe UDis86 do
  it "should have a VERSION constant" do
    UDis86.const_defined?('VERSION').should == true
  end
end
