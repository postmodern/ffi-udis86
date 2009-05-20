require 'udis86/types'
require 'udis86/operand'
require 'udis86/ffi'

require 'ffi'

module FFI
  module UDis86
    class UD < FFI::Struct
      
      TYPES = [
        NONE = 0,
        #
        # 8 bit GRPs
        #
        R_AL = 1,
        R_CL = 2,
        R_DL = 3,
        R_BL = 4,
        R_AH = 5,
        R_CH = 6,
        R_DH = 7,
        R_BH = 8,
        R_SPL = 9,
        R_BPL = 10,
        R_SIL = 11,
        R_DIL = 12,
        R_R8B = 13,
        R_R9B = 14,
        R_R10B = 15,
        R_R11B = 16,
        R_R12B = 17,
        R_R13B = 18,
        R_R14B = 19,
        R_R15B = 20,
        #
        # 16 bit GRPs
        #
        R_AX = 21,
        R_CX = 22,
        R_DX = 23,
        R_BX = 24,
        R_SP = 25,
        R_BP = 26,
        R_SI = 27,
        R_DI = 28,
        R_R8W = 29,
        R_R9W = 30,
        R_R10W = 31,
        R_R11W = 32,
        R_R12W = 33,
        R_R13W = 34,
        R_R14W = 35,
        R_R15W = 36,
        #
        # 32 bit GRPs
        #
        R_EAX = 37,
        R_ECX = 38,
        R_EDX = 39,
        R_EBX = 40,
        R_ESP = 41,
        R_EBP = 42,
        R_ESI = 43,
        R_EDI = 44,
        R_R8D = 45,
        R_R9D = 46,
        R_R10D = 47,
        R_R11D = 48,
        R_R12D = 49,
        R_R13D = 50,
        R_R14D = 51,
        R_R15D = 52,
        #
        # 64 bit GRPs
        #
        R_RAX = 53,
        R_RCX = 54,
        R_RDX = 55,
        R_RBX = 56,
        R_RSP = 57,
        R_RBP = 58,
        R_RSI = 59,
        R_RDI = 60,
        R_R8 = 61,
        R_R9 = 62,
        R_R10 = 63,
        R_R11 = 64,
        R_R12 = 65,
        R_R13 = 66,
        R_R14 = 67,
        R_R15 = 68,
        #
        # Segments registers
        #
        R_ES = 69,
        R_CS = 70,
        R_SS = 71,
        R_DS = 72,
        R_FS = 73,
        R_GS = 74,
        #
        # Control registers
        #
        R_CR0 = 75,
        R_CR1 = 76,
        R_CR2 = 77,
        R_CR3 = 78,
        R_CR4 = 79,
        R_CR5 = 80,
        R_CR6 = 81,
        R_CR7 = 82,
        R_CR8 = 83,
        R_CR9 = 84,
        R_CR10 = 85,
        R_CR11 = 86,
        R_CR12 = 87,
        R_CR13 = 88,
        R_CR14 = 89,
        R_CR15 = 90,
        #
        # Debug registers
        #
        R_DR0 = 91,
        R_DR1 = 92,
        R_DR2 = 93,
        R_DR3 = 94,
        R_DR4 = 95,
        R_DR5 = 96,
        R_DR6 = 97,
        R_DR7 = 98,
        R_DR8 = 99,
        R_DR9 = 100,
        R_DR10 = 101,
        R_DR11 = 102,
        R_DR12 = 103,
        R_DR13 = 104,
        R_DR14 = 105,
        R_DR15 = 106,
        #
        # MMX registers
        #
        R_MM0 = 107,
        R_MM1 = 108,
        R_MM2 = 109,
        R_MM3 = 110,
        R_MM4 = 111,
        R_MM5 = 112,
        R_MM6 = 113,
        R_MM7 = 114,
        #
        # x87 registers
        #
        R_ST0 = 115,
        R_ST1 = 116,
        R_ST2 = 117,
        R_ST3 = 118,
        R_ST4 = 119,
        R_ST5 = 120,
        R_ST6 = 121,
        R_ST7 = 122,
        #
        # Extended multimedia registers
        #
        R_XMM0 = 123,
        R_XMM1 = 124,
        R_XMM2 = 125,
        R_XMM3 = 126,
        R_XMM4 = 127,
        R_XMM5 = 128,
        R_XMM6 = 129,
        R_XMM7 = 130,
        R_XMM8 = 131,
        R_XMM9 = 132,
        R_XMM10 = 133,
        R_XMM11 = 134,
        R_XMM12 = 135,
        R_XMM13 = 136,
        R_XMM14 = 137,
        R_XMM15 = 138,
        R_RIP = 139,
        #
        # Operand types
        #
        OP_REG = 140,
        OP_MEM = 141,
        OP_PTR = 142,
        OP_IMM = 143,
        OP_JIMM = 144,
        OP_CONST = 145
      ]

      layout :inp_hook, :ud_input_callback,
             :inp_curr, :uint8,
             :inp_fill, :uint8,
             :inp_file, :pointer,
             :inp_ctr, :uint8,
             :inp_buff, :pointer,
             :inp_buff_end, :pointer,
             :inp_end, :uint8,
             :translator, :ud_translator_callback,
             :insn_offset, :uint64,
             :insn_hexcode, [:char, 32],
             :insn_buffer, [:char, 64],
             :insn_fill, :uint,
             :dis_mode, :uint8,
             :pc, :uint64,
             :vendor, :uint8,
             :mapen, :pointer,
             :mnemonic, :uint,
             :operand, [Operand, 3],
             :error, :uint8,
             :pfx_rex, :uint8,
             :pfx_seg, :uint8,
             :pfx_opr, :uint8,
             :pfx_adr, :uint8,
             :pfx_lock, :uint8,
             :pfx_rep, :uint8,
             :pfx_repe, :uint8,
             :pfx_repne, :uint8,
             :pfx_insn, :uint8,
             :default64, :uint8,
             :opr_mode, :uint8,
             :adr_mode, :uint8,
             :br_far, :uint8,
             :br_near, :uint8,
             :implicit_addr, :uint8,
             :c1, :uint8,
             :c2, :uint8,
             :c3, :uint8,
             :inp_cache, [NativeType::UINT8, 256],
             :inp_sess, [NativeType::UINT8, 64],
             :itab_entry, :pointer

      def self.create(options={},&block)
        options = {:mode => 32, :syntax => :att}.merge(options)

        ud = self.new
        ud.init

        if options[:string]
          ud.buffer = options[:string]
        end

        ud.mode = options[:mode]
        ud.syntax = options[:syntax]

        if options[:vendor]
          ud.vendor = options[:vendor]
        end

        if options[:pc]
          ud.pc = options[:pc]
        end

        ud.input_callback(&block) if block

        return ud
      end

      def self.open(path,options={},&block)
        File.open(path) do |file|
          ud = self.create(options) { |ud| file.getc }

          block.call(ud) if block
        end

        return nil
      end

      def init
        UDis86.ud_init(self)
        return self
      end

      def buffer
        self[:inp_buff]
      end

      def buffer=(data)
        data = data.to_s

        UDis86.ud_set_input_buffer(self, data, data.length)
        return data
      end

      def input_callback(&block)
        if block
          @input_callback = block

          UDis86.ud_set_input_hook(self, @input_callback)
        end

        return @input_callback
      end

      def mode
        self[:dis_mode]
      end

      def mode=(new_mode)
        UDis86.ud_set_mode(self, new_mode)
        return self
      end

      def syntax=(new_syntax)
        new_syntax = new_syntax.to_s
        func_name = UDis86::SYNTAX[new_syntax.downcase.to_sym]

        unless func_name
          raise(ArgumentError,"unknown syntax name #{new_syntax}",caller)
        end

        UDis86.ud_set_syntax(self, UDis86.method(func_name))
        return new_syntax
      end

      def vendor
        self[:vendor]
      end

      def vendor=(new_vendor)
        UDis86.ud_set_vendor(self, new_vendor)
        return new_vendor
      end

      def pc=(new_pc)
        UDis86.ud_set_pc(self, new_pc)
        return new_pc
      end

      def skip(n)
        UDis86.ud_input_skip(self, n)
        return self
      end

      def to_asm
        UDis86.ud_insn_asm(self)
      end

      def operands
        self[:operand].entries
      end

      def next_insn
        UDis86.ud_disassemble(self)
        return self
      end

      def disassemble(&block)
        until UDis86.ud_disassemble(self) == 0
          block.call(self) if block
        end

        return self
      end

      alias :disas :disassemble

    end
  end
end
