require 'ffi'

module FFI
  module UDis86
    class OperandPointer < FFI::Struct
      layout :seg, :uint16,
             :off, :uint32
    end
  end
end
