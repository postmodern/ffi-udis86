# encoding: US-ASCII
require 'spec_helper'

require 'ffi/udis86/ud'

describe FFI::UDis86::UD do
  describe ".create" do
    it "should accept a :mode option" do
      ud = described_class.create(:mode => 16)
      expect(ud.mode).to be == 16
    end

    it "should accept a :syntax option" do
      expect {
        described_class.create(:syntax => :att)
      }.to_not raise_error(ArgumentError)
    end

    it "should accept a :vendor option" do
      ud = described_class.create(:vendor => :amd)
      expect(ud.vendor).to be(:amd)
    end

    it "should accept a :pc option" do
      ud = described_class.create(:pc => 0x400000)
      expect(ud.pc).to be == 0x400000
    end

    it "should accept a :buffer option" do
      ud = described_class.create(:buffer => "\x90\x90\x90")
      expect(ud.input_buffer).to be == "\x90\x90\x90"
    end

    it "should accept a block as an input callback" do
      bytes = [0x80, -1]

      ud = described_class.create { |ud| bytes.shift }

      expect(ud.next_insn).to be == 1
      expect(ud.to_hex).to be == '80'

      expect(ud.next_insn).to be == 0
    end
  end

  describe ".open" do
    let(:hex) { %w[90 90 c3] }

    it "should be able to open files" do
      described_class.open(fixture_path('simple')) do |ud|
        expect(ud.next_insn).to be == 1
        expect(ud.to_hex).to be == hex[0]

        expect(ud.next_insn).to be == 1
        expect(ud.to_hex).to be == hex[1]

        expect(ud.next_insn).to be == 1
        expect(ud.to_hex).to be == hex[2]

        expect(ud.next_insn).to be == 0
      end
    end
  end

  describe "disassember" do
    let(:hex) { %w[90 90 c3] }
    let(:ops) { %w[nop nop ret] }

    before(:each) do
      File.open(fixture_path('simple'),'rb') do |file|
        @string = file.read
        @ud     = described_class.create(:buffer => @string)
      end
    end

    describe "#mode=" do
      it "should allow setting the mode" do
        @ud.mode = 64

        expect(@ud.mode).to be == 64
      end
    end

    describe "#syntax=" do
      it "should allow setting the syntax" do
        expect {
          @ud.syntax = :att
        }.to_not raise_error(ArgumentError)
      end
    end

    describe "#vendor" do
      it "should allow setting the vendor" do
        @ud.vendor = :amd

        expect(@ud.vendor).to be(:amd)
      end
    end

    describe "#pc" do
      it "should allow setting the program counter (PC)" do
        @ud.pc = 0x400000

        expect(@ud.pc).to be == 0x400000
      end
    end

    describe "#input_buffer" do
      it "should provide read access to the input buffer" do
        expect(@ud.input_buffer).to be == @string
      end
    end

    describe "#input_buffer=" do
      let(:buffer) { "\x90\x90\xc3" }

      it "should allow setting the input buffer" do
        @ud.input_buffer = buffer

        expect(@ud.input_buffer).to be == buffer
      end

      context "when given an Array of bytes" do
        let(:array) { [0x90, 0x90, 0xc3] }

        it "should convert them to an input buffer" do
          @ud.input_buffer = array

          expect(@ud.input_buffer).to be == buffer
        end
      end
    end

    describe "#input_callback" do
      it "should allow setting an input callback" do
        bytes = [0x90, 0xc3]

        @ud.input_callback do |ud|
          bytes.shift || -1
        end

        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == 'nop'

        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == 'ret'

        expect(@ud.next_insn).to be == 0
      end
    end

    describe "#skip" do
      it "should allow the skipping of input bytes" do
        @ud.skip(2)
        @ud.next_insn

        expect(@ud.to_asm).to be == ops.last
      end
    end

    describe "#next_insn" do
      it "should get the next instruction" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == ops[0]

        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == ops[1]

        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == ops[2]

        expect(@ud.next_insn).to be == 0
      end
    end

    describe "#insn_length" do
      it "should specify the instruction length" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.insn_length).to be == 1
      end
    end

    describe "#insn_offset" do
      it "should specify the instruction offset" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.next_insn).to be == 1

        expect(@ud.insn_offset).to be == 1
      end
    end

    describe "#insn_ptr" do
      it "should provide a pointer to the instruction bytes" do
        expect(@ud.next_insn).to be == 1

        expect(@ud.insn_ptr.get_string(0)).to be == "\x90"
      end
    end

    describe "#to_hex" do
      it "should provide hex form of the bytes" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.to_hex).to be == hex.first
      end
    end

    describe "#mnemonic_code" do
      it "should provide the mnemonic code of the disassembled instructions" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.mnemonic_code).to be(:ud_inop)
      end
    end

    describe "#mnemonic" do
      it "should provide the mnemonic of the disassembled instructions" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.mnemonic).to be(:nop)
      end
    end

    describe "#to_asm" do
      it "should provide the assembly form of the disassembled instructions" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.to_asm).to be == ops[0]
      end
    end

    describe "#operands" do
      it "should provide the disassembled operands of the instruction" do
        expect(@ud.next_insn).to be == 1
        expect(@ud.operands).to be == []
      end
    end

    describe "#disassemble" do
      it "should disassemble every byte" do
        disassembled = []

        @ud.disassemble { |ud| disassembled << ud.to_asm }

        expect(disassembled).to be == ops
      end
    end
  end
end
