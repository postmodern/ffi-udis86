require 'udis86/typedefs'
require 'udis86/ud'

require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    ffi_lib 'libudis86'

    CALLBACKS = []

    callback :ud_input_callback, [], :int
    callback :ud_translator_callback, [:pointer], :void

    attach_function :ud_init, [:pointer], :void
    attach_function :ud_set_input_hook, [:pointer, :ud_input_callback], :void
    attach_function :ud_set_input_buffer, [:pointer, :pointer, :size_t], :void

    MODE_32 = 32
    MODE_64 = 64

    attach_function :ud_set_mode, [:pointer, :uint8], :void
    attach_function :ud_set_pc, [:pointer], :void

    SYNTAX_INTEL = 0
    SYNTAX_ATT = 1

    attach_function :ud_set_syntax, [:pointer, :ud_translator_callback], :void

    VENDOR_INTEL = 0
    VENDOR_ATT = 1

    attach_function :ud_set_vendor, [:pointer, :uint], :void
    attach_function :ud_disassemble, [:pointer], :uint
    attach_function :ud_insn_len, [:pointer], :uint
    attach_function :ud_insn_off, [:pointer], :uint64
    attach_function :ud_insn_hex, [:pointer], :string
    attach_function :ud_insn_ptr, [:pointer], :pointer
    attach_function :ud_insn_asm, [:pointer], :string
    attach_function :ud_input_skip, [:pointer, :size_t], :void

    def UDis86.create_callback(&block)
      CALLBACKS << block
      return CALLBACKS.last
    end

    def UDis86.open(path,&block)
      ud = UD.new
      ud_ptr = MemoryPointer.new(ud)

      UDis86.ud_init(ud_ptr)

      File.open(path) do |file|
        hook = UDis86.create_callback { file.getc }

        UDis86.ud_set_input_hook(ud_ptr,hook)

        block.call(ud) if block
      end

      return ud
    end

  end
end
