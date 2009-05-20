require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    # 16-bit disassembly mode
    MODE_16 = 16

    # 32-bit disassembly mode
    MODE_32 = 32

    # 64-bit disassembly mode
    MODE_64 = 64

    # Vendors
    VENDORS = {
      :amd => 0,
      :intel => 1
    }

    # Syntaxes
    SYNTAX = {
      :att => :ud_translate_att,
      :intel => :ud_translate_intel
    }

    callback :ud_input_callback, [:pointer], :int
    callback :ud_translator_callback, [:pointer], :void
  end
end
