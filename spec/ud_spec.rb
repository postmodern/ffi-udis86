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

    it "should accept a :buffer option" do
      ud = UD.create(:buffer => "\x90\x90\x90")
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
      UD.open(File.join(Helpers::FILES_DIR,'simple')) do |ud|
        ud.next_insn.should == 1
        ud.to_hex.should == '90'

        ud.next_insn.should == 1
        ud.to_hex.should == '90'

        ud.next_insn.should == 1
        ud.to_hex.should == 'c3'

        ud.next_insn.should == 0
      end
    end
  end

  describe "disassember" do
    before(:each) do
      File.open(File.join(Helpers::FILES_DIR,'simple'),'rb') do |file|
        @string = file.read
        @ud = UD.create(:buffer => @string)
      end
    end

    it "should allow setting the mode" do
      @ud.mode = 64

      @ud.mode.should == 64
    end

    it "should allow setting the syntax" do
      lambda {
        @ud.syntax = :att
      }.should_not raise_error(RuntimeError)
    end

    it "should allow setting the vendor" do
      @ud.vendor = :amd

      @ud.vendor.should == :amd
    end

    it "should allow setting the program counter (PC)" do
      @ud.pc = 0x400000

      @ud.pc.should == 0x400000
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

    it "should get the next instruction" do
      @ud.next_insn.should == 1
      @ud.to_asm.should == 'nop '

      @ud.next_insn.should == 1
      @ud.to_asm.should == 'nop '

      @ud.next_insn.should == 1
      @ud.to_asm.should == 'ret '

      @ud.next_insn.should == 0
    end

    it "should specify the instruction length" do
      @ud.next_insn.should == 1
      @ud.insn_length.should == 1
    end

    it "should specify the instruction offset" do
      @ud.next_insn.should == 1
      @ud.next_insn.should == 1

      @ud.insn_offset.should == 1
    end

    it "should provide a pointer to the instruction bytes" do
      @ud.next_insn.should == 1

      @ud.insn_ptr.get_string(0).should == "\x90"
    end

    it "should provide hex form of the bytes" do
      @ud.next_insn.should == 1
      @ud.to_hex.should == '90'
    end

    it "should provide the assembly form of the disassembled instructions" do
      @ud.next_insn.should == 1
      @ud.to_asm.should == 'nop '
    end

    it "should provide the disassembled operands of the instruction" do
      @ud.next_insn.should == 1
      @ud.operands.should == []
    end

    it "should disassemble every byte" do
      ops = ['nop ', 'nop ', 'ret ']

      @ud.disassemble do |ud|
        ud.to_asm.should == ops.shift
      end
    end
  end
end
