require 'ffi'

module FFI
  module UDis86
    class OperandPointer < FFI::Struct

      layout :seg, :uint16,
             :off, :uint32

      def seg
        self[:seg]
      end

      alias segment seg

      def off
        self[:off]
      end

      alias offset off

    end
  end
end
