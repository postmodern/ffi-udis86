require 'ffi/udis86/types'
require 'ffi/udis86/operand'
require 'ffi/udis86/udis86'

require 'ffi'

module FFI
  module UDis86
    class UD < FFI::Struct

      include Enumerable

      layout :inp_hook, :ud_input_callback,
             :inp_file, :pointer,
             :inp_buf, :pointer,
             :inp_buf_size, :size_t,
             :inp_buf_index, :size_t,
             :inp_curr, :uint8,
             :inp_ctr, :size_t,
             :inp_sess, [:uint8, 64],
             :inp_end, :int,
             :inp_peek, :int,
             :translator, :ud_translator_callback,
             :insn_offset, :uint64,
             :insn_hexcode, [:char, 64],
             :asm_buf, :pointer,
             :asm_buf_size, :size_t,
             :asm_buf_fill, :size_t,
             :asm_buf_int, [:char, 128],
             :sym_resolver, :ud_sym_resolver_callback,
             :dis_mode, :uint8,
             :pc, :uint64,
             :vendor, :uint8,
             :mnemonic, :ud_mnemonic_code,
             :operand, [Operand, 4],
             :error, :uint8,
             :_rex, :uint8,
             :pfx_rex, :uint8,
             :pfx_seg, :uint8,
             :pfx_opr, :uint8,
             :pfx_adr, :uint8,
             :pfx_lock, :uint8,
             :pfx_str, :uint8,
             :pfx_rep, :uint8,
             :pfx_repe, :uint8,
             :pfx_repne, :uint8,
             :opr_mode, :uint8,
             :adr_mode, :uint8,
             :br_far, :uint8,
             :br_near, :uint8,
             :have_modrm, :uint8,
             :modrm, :uint8,
             :vex_op, :uint8,
             :vex_b1, :uint8,
             :vex_b2, :uint8,
             :primary_opcode, :uint8,
             :user_opaque_data, :pointer,
             :itab_entry, :pointer,
             :le, :pointer

      #
      # Creates a new disassembler object.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [Integer] :mode (32)
      #   The mode of disassembly, can either 16, 32 or 64.
      #
      # @option options [Integer] :syntax (:intel)
      #   The assembly syntax the disassembler will emit, can be either
      #   `:att` or `:intel`.
      #
      # @option options [String] :buffer
      #   A buffer to disassemble.
      #
      # @option options [Symbol] :vendor
      #   Sets the vendor of whose instructions to choose from. Can be
      #   either `:amd` or `:intel`.
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
        ud = self.new
        ud.init

        ud.mode = (options[:mode] || 32)

        if options[:buffer]
          ud.input_buffer = options[:buffer]
        end

        ud.syntax = (options[:syntax] || :intel)

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
      #   Additional options for the disassembler.
      #
      # @option options [Integer] :mode (32)
      #   The mode of disassembly, can either 16, 32 or 64.
      #
      # @option options [Integer] :syntax (:intel)
      #   The assembly syntax the disassembler will emit, can be either
      #   `:att` or `:intel`.
      #
      # @option options [String] :buffer
      #   A buffer to disassemble.
      #
      # @option options [Symbol] :vendor
      #   Sets the vendor of whose instructions to choose from. Can be
      #   either `:amd` or `:intel`.
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
      def self.open(path,options={})
        File.open(path,'rb') do |file|
          ud = self.create(options) do |ud|
            if (b = file.getc)
              b.ord
            else
              -1
            end
          end

          yield ud if block_given?
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
        if @input_buffer
          @input_buffer.get_bytes(0,@input_buffer.total)
        else
          ''
        end
      end

      #
      # Sets the contents of the input buffer for the disassembler.
      #
      # @param [Array<Integer>, String] data
      #   The new contents to use for the input buffer.
      #
      # @return [String]
      #   The new contents of the input buffer.
      #
      # @raise [RuntimeError]
      #   The given input buffer was neither a String or an Array of bytes.
      #
      def input_buffer=(data)
        @input_buffer = FFI::Buffer.new_in(:uint8, data.length)

        if data.kind_of?(Array)
          @input_buffer.put_array_of_uint8(0,data)
        elsif data.kind_of?(String)
          @input_buffer.put_bytes(0,data.encode(Encoding::ASCII_8BIT))
        else
          raise(RuntimeError,"input buffer must be either a String or an Array of bytes",caller)
        end

        UDis86.ud_set_input_buffer(self,@input_buffer,@input_buffer.total)
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
          @input_callback = Proc.new { |ptr| block.call(self) }

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
        unless MODES.include?(new_mode)
          raise(RuntimeError,"invalid disassembly mode #{new_mode}",caller)
        end

        UDis86.ud_set_mode(self,new_mode)
        return new_mode
      end

      #
      # Sets the assembly syntax that the disassembler will emit.
      #
      # @param [Symbol, String] new_syntax
      #   The new assembler syntax the disassembler will emit. Can be
      #   either `:att` or `:intel`.
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
      # The vendor of whose instructions are to be chosen from during
      # disassembly.
      #
      # @return [Symbol]
      #   The vendor name, may be either `:amd` or `:intel`.
      #
      def vendor
        VENDORS[self[:vendor]]
      end

      #
      # Sets the vendor, of whose instructions are to be chosen from
      # during disassembly.
      #
      # @param [Symbol] new_vendor
      #   The new vendor to use, can be either `:amd` or `:intel`.
      #
      # @return [Symbol]
      #   The new vendor to use.
      #
      def vendor=(new_vendor)
        UDis86.ud_set_vendor(self,VENDORS.index(new_vendor))
        return new_vendor
      end

      #
      # Returns the current value of the Program Counter (PC).
      #
      # @return [Integer]
      #   The value of the PC.
      #
      def pc
        self[:pc]
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
      # The mnemonic code of the last disassembled instruction.
      #
      # @return [Symbol]
      #   The mnemonic code.
      #
      # @since 0.2.0
      #
      def insn_mnemonic
        UDis86.ud_insn_mnemonic(self)
      end

      alias mnemonic_code insn_mnemonic

      #
      # The mnemonic string of the last disassembled instruction.
      #
      # @return [Symbol]
      #   The mnemonic string.
      #
      def mnemonic
        UDis86.ud_lookup_mnemonic(self[:mnemonic]).to_sym
      end

      #
      # The 64-bit mode REX prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The 64-bit REX prefix.
      #
      def rex_prefix
        self[:pfx_rex]
      end

      #
      # The segment register prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The segment register prefix.
      #
      def segment_prefix
        self[:pfx_seg]
      end

      #
      # The operand-size prefix (66h) of the last disassembled instruction.
      #
      # @return [Integer]
      #   The operand-size prefix.
      #
      def operand_prefix
        self[:pfx_opr]
      end

      #
      # The address-size prefix (67h) of the last disassembled instruction.
      #
      # @return [Integer]
      #   The address-size prefix.
      #
      def address_prefix
        self[:pfx_adr]
      end

      #
      # The lock prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The lock prefix.
      #
      def lock_prefix
        self[:pfx_lock]
      end

      #
      # The rep prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The rep prefix.
      #
      def rep_prefix
        self[:pfx_rep]
      end

      #
      # The repe prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The repe prefix.
      #
      def repe_prefix
        self[:pfx_repe]
      end

      #
      # The repne prefix of the last disassembled instruction.
      #
      # @return [Integer]
      #   The repne prefix.
      #
      def repne_prefix
        self[:pfx_repne]
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

      #
      # Returns the hexadecimal representation of the disassembled
      # instruction.
      #
      # @return [String]
      #   The hexadecimal form of the disassembled instruction.
      #
      def to_hex
        UDis86.ud_insn_hex(self)
      end

      alias to_s to_asm

      #
      # Returns the operands for the last disassembled instruction.
      #
      # @return [Array<Operand>]
      #   The operands of the instruction.
      #
      def operands
        self[:operand].entries.select do |operand|
          OPERAND_TYPES.include?(operand.type)
        end
      end

      #
      # Disassembles the next instruction in the input stream.
      #
      # @return [UD]
      #   The disassembler.
      #
      def next_insn
        UDis86.ud_disassemble(self)
      end

      #
      # Returns the number of bytes that were disassembled.
      #
      # @return [Integer]
      #   The number of bytes disassembled.
      #
      def insn_length
        UDis86.ud_insn_len(self)
      end

      #
      # Returns the starting offset of the disassembled instruction
      # relative to the initial value of the Program Counter (PC).
      #
      # @return [Integer]
      #   The offset of the instruction.
      #
      def insn_offset
        UDis86.ud_insn_off(self)
      end

      #
      # Returns the pointer to the buffer holding the disassembled
      # instruction bytes.
      #
      # @return [FFI::Pointer]
      #   The pointer to the instruction buffer.
      #
      def insn_ptr
        UDis86.ud_insn_ptr(self)
      end

      #
      # Returns the operand at the nth (starting with 0) position of the
      # instruction.
      #
      # @param [Integer] index
      #   The given index to check.
      #
      # @return [Operand, nil]
      #   The operand at the given index, or `nil` if the index is out of range.
      #
      # @since 0.2.0
      #
      def insn_opr(index=0)
        unless (ptr = UDis86.ud_insn_opr(self,index)).null?
          Operand.new(ptr)
        end
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
      def disassemble
        until UDis86.ud_disassemble(self) == 0
          yield self if block_given?
        end

        return self
      end

      alias disas disassemble
      alias each disassemble

    end
  end
end
