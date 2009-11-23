require 'udis86/typedefs'
require 'udis86/types'
require 'udis86/ud'

require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    ffi_lib 'libudis86'

    attach_function :ud_init, [:pointer], :void
    attach_function :ud_set_input_hook, [:pointer, :ud_input_callback], :void
    attach_function :ud_set_input_buffer, [:pointer, :pointer, :size_t], :void
    attach_function :ud_set_mode, [:pointer, :uint8], :void
    attach_function :ud_set_pc, [:pointer, :uint64], :void
    attach_function :ud_translate_att, [:pointer], :void
    attach_function :ud_translate_intel, [:pointer], :void
    attach_function :ud_set_syntax, [:pointer, :ud_translator_callback], :void
    attach_function :ud_set_vendor, [:pointer, :ud_vendor], :void
    attach_function :ud_disassemble, [:pointer], :uint
    attach_function :ud_insn_len, [:pointer], :uint
    attach_function :ud_insn_off, [:pointer], :uint64
    attach_function :ud_insn_hex, [:pointer], :string
    attach_function :ud_insn_ptr, [:pointer], :pointer
    attach_function :ud_insn_asm, [:pointer], :string
    attach_function :ud_input_skip, [:pointer, :size_t], :void
  end
end
