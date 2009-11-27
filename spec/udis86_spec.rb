require 'udis86/version'

require 'spec_helper'

describe UDis86 do
  it "should have a VERSION constant" do
    UDis86.const_defined?('VERSION').should == true
  end

  describe "types" do
    it "should define syntices" do
      SYNTAX[:att].should == :ud_translate_att
      SYNTAX[:intel].should == :ud_translate_intel
    end

    it "should define mappings from :ud_type to register names" do
      ud_type = UDis86.enum_type(:ud_type)

      UDis86::REGS.each do |type,name|
        :"ud_r_#{name}".should == type
        ud_type[ud_type[type]].should == type
      end
    end
  end
end
