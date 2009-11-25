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

      ud.next_insn.should == 1
      ud.to_hex.should == '80'

      ud.next_insn.should == 0
    end
  end

  describe "open" do
    it "should be able to open files" do
      UD.open(File.join(Helpers::FILES_DIR,'simple.o')) do |ud|
        ud.next_insn.should == 1
        ud.to_hex.should == '90'

        ud.next_insn.should == 0
      end
    end
  end

  describe "disassember" do
    before(:each) do
      @string = "\x90\x90\xc3"
      @ud = UD.create(:string => @string)
    end

    it "should provide read access to the input buffer" do
      @ud.input_buffer.should == @string
    end

    it "should allow setting the input buffer" do
      new_input = "\xc3"

      @ud.input_buffer = new_input
      @ud.input_buffer.should == new_input
    end

    it "should allow setting an input callback" do
      bytes = [0x90, 0xc3]

      @ud.input_callback do |ud|
        bytes.shift || -1
      end

      @ud.next_insn.should == 1
      @ud.to_asm.should == 'nop '

      @ud.next_insn.should == 1
      @ud.to_asm.should == 'ret '

      @ud.next_insn.should == 0
    end

    it "should allow the skipping of input bytes" do
      @ud.skip(2)

      @ud.next_insn
      @ud.to_asm.should == 'ret '
    end

    it "should provide hex form of the bytes" do
      @ud.next_insn.should == 1
      @ud.to_hex.should == '90'
    end

    it "should provide the assembly form of the disassembled instructions" do
      @ud.next_insn.should == 1
      @ud.to_asm.should == 'nop '
    end
  end
end
