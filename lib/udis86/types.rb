require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    enum :ud_mode, [
      :ud_mode_16, 16,
      :ud_mode_32, 32,
      :ud_mode_64, 64
    ]

    enum :ud_vendors, [:amd, :intel]

    # Syntaxes
    SYNTAX = {
      :att => :ud_translate_att,
      :intel => :ud_translate_intel
    }

    callback :ud_input_callback, [:pointer], :int
    callback :ud_translator_callback, [:pointer], :void
  end
end
