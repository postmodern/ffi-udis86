require 'udis86/ud'

require 'spec_helper'
require 'helpers/files'

describe UD do
  include Helpers

  describe "create" do
    it "should accept a :mode option" do
      ud = UD.create(:mode => 16)
      ud.mode.should == 16
    end

    it "should accept a :syntax option" do
      lambda {
        UD.create(:syntax => :att)
      }.should_not raise_error(ArgumentError)
    end

    it "should accept a :vendor option" do
      ud = UD.create(:vendor => :amd)
      ud.vendor.should == :amd
    end

    it "should accept a :pc option" do
      ud = UD.create(:pc => 0x400000)
      ud.pc.should == 0x400000
    end

    it "should accept a :string option" do
      ud = UD.create(:string => "\x90\x90\x90")
      ud.input_buffer.should == "\x90\x90\x90"
    end

    it "should accept a block as an input callback" do
      bytes = [0x80, -1]

      ud = UD.create { |ud| bytes.shift }

      ud.next_insn
      ud.to_hex.should == '80'
    end
  end

  it "should be able to open files" do
    UD.open(File.join(Helpers::FILES_DIR,'simple.o')) do |ud|
      ud.next_insn
      ud.to_hex.should == '90'
    end
  end
end
