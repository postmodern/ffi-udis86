require 'ffi'

module FFI
  module UDis86
    extend FFI::Library

    CALLBACKS = []

    callback :ud_input_callback, [:pointer], :int
    callback :ud_translator_callback, [:pointer], :void

    def UDis86.create_callback(&block)
      CALLBACKS << block
      return CALLBACKS.last
    end
  end
end
