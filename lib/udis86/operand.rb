require 'udis86/operand_value'

require 'ffi'

module FFI
  module UDis86
    class Operand < FFI::Struct

      layout :type, :ud_type,
             :size, :uint8,
             :value, OperandValue,
             :base, :uint,
             :index, :uint,
             :offset, :uint8,
             :scale, :uint8

    end
  end
end
