require 'udis86/typedefs'

require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    ffi_lib 'udis86'

    callback :ud_input_callback, [], :int
    callback :ud_translator_callback, [:pointer], :void

    attach_function :ud_init, [:pointer], :void
    attach_function :ud_set_input_hook, [:pointer, :ud_input_callback], :void
    attach_function :ud_set_input_buffer, [:pointer, :pointer, :size_t], :void
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

  end
end
