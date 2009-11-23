require 'ffi'

module FFI
  module UDis86
    class OperandPointer < FFI::Struct

      layout :seg, :uint16,
             :off, :uint32

      #
      # Returns the pointer segment.
      #
      # @return [Integer]
      #   The pointer segment.
      #
      def seg
        self[:seg]
      end

      alias segment seg

      #
      # Returns the offset within the segment of the pointer.
      #
      # @return [Integer]
      #   The offset within the segment.
      #
      def off
        self[:off]
      end

      alias offset off

    end
  end
end
