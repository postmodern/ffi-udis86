require 'udis86/types'
require 'udis86/operand'
require 'udis86/ffi'

require 'ffi'

module FFI
  module UDis86
    class UD < FFI::Struct

      include Enumerable
      
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
          ud.input_buffer = options[:string]
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
          ud = self.create(options) { |ud| file.getc || -1 }

          block.call(ud) if block
        end

        return nil
      end

      def init
        UDis86.ud_init(self)
        return self
      end

      def input_buffer
        self[:inp_buff]
      end

      def input_buffer=(data)
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

      alias :to_s :to_asm

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
      alias :each :disassemble

    end
  end
end
