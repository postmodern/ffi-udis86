require 'ffi/udis86/ud'

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
    let(:hex) { ['90', '90', 'c3'] }

    it "should be able to open files" do
      UD.open(File.join(Helpers::FILES_DIR,'simple')) do |ud|
        ud.next_insn.should == 1
        ud.to_hex.should == hex[0]

        ud.next_insn.should == 1
        ud.to_hex.should == hex[1]

        ud.next_insn.should == 1
        ud.to_hex.should == hex[2]

        ud.next_insn.should == 0
      end
    end
  end

  describe "disassember" do
    let(:hex) { ['90', '90', 'c3'] }
    let(:ops) { ['nop ', 'nop ', 'ret '] }

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

    describe "#input_buffer" do
      it "should provide read access to the input buffer" do
        @ud.input_buffer.should == @string
      end
    end

    describe "#input_buffer=" do
      let(:buffer) { "\x90\x90\xc3" }

      it "should allow setting the input buffer" do
        @ud.input_buffer = buffer

        @ud.input_buffer.should == buffer
      end

      context "when given an Array of bytes" do
        let(:array) { [0x90, 0x90, 0xc3] }

        it "should convert them to an input buffer" do
          @ud.input_buffer = array

          @ud.input_buffer.should == buffer
        end
      end
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
      @ud.to_asm.should == ops.last
    end

    it "should get the next instruction" do
      @ud.next_insn.should == 1
      @ud.to_asm.should == ops[0]

      @ud.next_insn.should == 1
      @ud.to_asm.should == ops[1]

      @ud.next_insn.should == 1
      @ud.to_asm.should == ops[2]

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
      @ud.to_hex.should == hex.first
    end

    it "should provide the mnemonic code of the disassembled instructions" do
      @ud.next_insn.should == 1
      @ud.mnemonic_code.should == :ud_inop
    end

    it "should provide the mnemonic of the disassembled instructions" do
      @ud.next_insn.should == 1
      @ud.mnemonic.should == :nop
    end

    it "should provide the assembly form of the disassembled instructions" do
      @ud.next_insn.should == 1
      @ud.to_asm.should == ops[0]
    end

    it "should provide the disassembled operands of the instruction" do
      @ud.next_insn.should == 1
      @ud.operands.should == []
    end

    it "should disassemble every byte" do
      disassembled = []

      @ud.disassemble { |ud| disassembled << ud.to_asm }

      disassembled.should == ops
    end
  end
end
