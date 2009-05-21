require 'udis86/operand_pointer'

require 'ffi'

module FFI
  module UDis86
    class OperandValue < FFI::Union
      layout :sbyte, :int8,
             :ubyte, :uint8,
             :sword, :int16,
             :uword, :uint16,
             :sdword, :int32,
             :udword, :uint32,
             :sqword, :int64,
             :uqword, :uint64,
             :ptr, OperandPointer
    end
  end
end
