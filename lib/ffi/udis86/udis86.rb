require 'ffi/udis86/types'

require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    ffi_lib ['udis86', 'libudis86.so.0']

    attach_function :ud_init, [:pointer], :void
    attach_function :ud_set_mode, [:pointer, :uint8], :void
    attach_function :ud_set_pc, [:pointer, :uint64], :void
    attach_function :ud_set_input_hook, [:pointer, :ud_input_callback], :void
    attach_function :ud_set_input_buffer, [:pointer, :pointer, :size_t], :void
    attach_function :ud_set_input_file, [:pointer, :pointer], :void
    attach_function :ud_set_vendor, [:pointer, :uint8], :void
    attach_function :ud_set_syntax, [:pointer, :ud_translator_callback], :void
    attach_function :ud_input_skip, [:pointer, :size_t], :void
    attach_function :ud_input_end, [:pointer], :int
    attach_function :ud_decode, [:pointer], :uint
    attach_function :ud_disassemble, [:pointer], :uint
    attach_function :ud_translate_intel, [:pointer], :void
    attach_function :ud_translate_att, [:pointer], :void
    attach_function :ud_insn_asm, [:pointer], :string
    attach_function :ud_insn_ptr, [:pointer], :pointer
    attach_function :ud_insn_off, [:pointer], :uint64
    attach_function :ud_insn_hex, [:pointer], :string
    attach_function :ud_insn_len, [:pointer], :uint
    attach_function :ud_insn_opr, [:pointer], :pointer
    attach_function :ud_opr_is_sreg, [:pointer], :int
    attach_function :ud_opr_is_gpr, [:pointer], :int
    attach_function :ud_insn_mnemonic, [:pointer], :ud_mnemonic_code
    attach_function :ud_lookup_mnemonic, [:ud_mnemonic_code], :string
    attach_function :ud_set_user_opaque_data, [:pointer, :pointer], :void
    attach_function :ud_get_user_opaque_data, [:pointer], :pointer
    attach_function :ud_set_asm_buffer, [:pointer, :pointer, :size_t], :void
    attach_function :ud_set_sym_resolver, [:pointer, :ud_sym_resolver_callback], :void
  end
end
