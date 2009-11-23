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
             :vendor, :ud_vendor,
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

      #
      # Creates a new disassembler object.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :mode (32)
      #   The mode of disassembly, can either 16, 32 or 64.
      #
      # @option options [Integer] :syntax (:att)
      #   The assembly syntax the disassembler will emit, can be either
      #   +:att+ or +:intel+.
      #
      # @option options [String] :string
      #   A String to disassemble.
      #
      # @option options [Symbol] :vendor
      #   Sets the vendor of whose instructions to choose from. Can be
      #   either +:amd+ or +:intel+.
      #
      # @option options [Integer] :pc
      #   Initial value of the Program Counter (PC).
      #
      # @yield [ud]
      #   If a block is given, it will be used as an input callback to
      #   return the next byte to disassemble. When the block returns
      #   -1, the disassembler will stop processing input.
      #
      # @yieldparam [UD] ud
      #   The disassembler.
      #
      # @return [UD]
      #   The newly created disassembler.
      #
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

      #
      # Opens a file and disassembles it.
      #
      # @param [String] path
      #   The path to the file.
      #
      # @param [Hash] options
      #   Additional dissaembly options.
      #
      # @option options [Integer] :mode (32)
      #   The mode of disassembly, can either 16, 32 or 64.
      #
      # @option options [Integer] :syntax (:att)
      #   The assembly syntax the disassembler will emit, can be either
      #   +:att+ or +:intel+.
      #
      # @option options [String] :string
      #   A String to disassemble.
      #
      # @option options [Symbol] :vendor
      #   Sets the vendor of whose instructions to choose from. Can be
      #   either +:amd+ or +:intel+.
      #
      # @option options [Integer] :pc
      #   Initial value of the Program Counter (PC).
      #
      # @yield [ud]
      #   If a block is given, it will be passed the newly created
      #   UD object, configured to disassembler the file.
      #
      # @yieldparam [UD] ud
      #   The newly created disassembler.
      #
      def self.open(path,options={},&block)
        File.open(path) do |file|
          ud = self.create(options) { |ud| file.getc || -1 }

          block.call(ud) if block
        end

        return nil
      end

      #
      # Initializes the disassembler.
      #
      # @return [UD]
      #   The initialized disassembler.
      #
      def init
        UDis86.ud_init(self)
        return self
      end

      #
      # Returns the input buffer used by the disassembler.
      #
      # @return [String]
      #   The current contents of the input buffer.
      #
      def input_buffer
        self[:inp_buff]
      end

      #
      # Sets the contents of the input buffer for the disassembler.
      #
      # @param [String] data
      #   The new contents to use for the input buffer.
      #
      # @return [String]
      #   The new contents of the input buffer.
      #
      def input_buffer=(data)
        data = data.to_s

        UDis86.ud_set_input_buffer(self,data,data.length)
        return data
      end

      #
      # Sets the input callback for the disassembler.
      #
      # @yield [ud]
      #   If a block is given, it will be used to get the next byte of
      #   input to disassemble. When the block returns -1, the disassembler
      #   will stop processing input.
      #
      # @yieldparam [UD]
      #   The disassembler.
      #
      def input_callback(&block)
        if block
          @input_callback = Proc.new do |ptr|
            block.call(self)
          end

          UDis86.ud_set_input_hook(self,@input_callback)
        end

        return @input_callback
      end

      #
      # Returns the mode the disassembler is running in.
      #
      # @return [Integer]
      #   Returns either 16, 32 or 64.
      #
      def mode
        self[:dis_mode]
      end

      #
      # Sets the mode the disassembler will run in.
      #
      # @param [Integer] new_mode
      #   The mode the disassembler will run in. Can be either 16, 32 or 64.
      #
      # @return [Integer]
      #   The new mode of the disassembler.
      #
      def mode=(new_mode)
        UDis86.ud_set_mode(self,new_mode)
        return new_mode
      end

      #
      # Sets the assembly syntax that the disassembler will emit.
      #
      # @param [Symbol, String] new_syntax
      #   The new assembler syntax the disassembler will emit. Can be
      #   either +:att+ or +:intel+.
      #
      # @return [Symbol]
      #   The new assembly syntax being used.
      #
      def syntax=(new_syntax)
        new_syntax = new_syntax.to_s.downcase.to_sym
        func_name = UDis86::SYNTAX[new_syntax]

        unless func_name
          raise(ArgumentError,"unknown syntax name #{new_syntax}",caller)
        end

        UDis86.ud_set_syntax(self,UDis86.method(func_name))
        return new_syntax
      end

      #
      # The vendor of whose instructions are to be choosen from during
      # disassembly.
      #
      # @return [Symbol]
      #   The vendor name, may be either +:amd+ or +:intel+.
      #
      def vendor
        self[:vendor]
      end

      #
      # Sets the vendor, of whose instructions are to be choosen from
      # during disassembly.
      #
      # @param [Symbol] new_vendor
      #   The new vendor to use, can be either +:amd+ or +:intel+.
      #
      # @return [Symbol]
      #   The new vendor to use.
      #
      def vendor=(new_vendor)
        UDis86.ud_set_vendor(self,new_vendor)
        return new_vendor
      end

      #
      # Sets the value of the Program Counter (PC).
      #
      # @param [Integer] new_pc
      #   The new value to use for the PC.
      #
      # @return [Integer]
      #   The new value of the PC.
      #
      def pc=(new_pc)
        UDis86.ud_set_pc(self,new_pc)
        return new_pc
      end

      #
      # Causes the disassembler to skip a certain number of bytes in the
      # input stream.
      #
      # @param [Integer] n
      #   The number of bytes to skip.
      #
      # @return [UD]
      #   The disassembler.
      #
      def skip(n)
        UDis86.ud_input_skip(self,n)
        return self
      end

      #
      # Returns the assembly syntax for the last disassembled instruction.
      #
      # @return [String]
      #   The assembly syntax for the instruction.
      #
      def to_asm
        UDis86.ud_insn_asm(self)
      end

      alias :to_s :to_asm

      #
      # Returns the operands for the last disassembled instruction.
      #
      # @return [Array<Operand>]
      #   The operands of the instruction.
      #
      def operands
        self[:operand].entries
      end

      #
      # Disassembles the next instruction in the input stream.
      #
      # @return [UD]
      #   The disassembler.
      #
      def next_insn
        UDis86.ud_disassemble(self)
        return self
      end

      #
      # Reads each byte, disassembling each instruction.
      #
      # @yield [ud]
      #   If a block is given, it will be passed the disassembler after
      #   each instruction has been disassembled.
      #
      # @yieldparam [UD] ud
      #   The disassembler.
      #
      # @return [UD]
      #   The disassembler.
      #
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
