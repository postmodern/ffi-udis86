require 'ffi'

module FFI
  module UDis86
    class OperandPointer < FFI::Struct

      layout :segment, :uint16,
             :offset, :uint32

      #
      # Returns the pointer segment.
      #
      # @return [Integer]
      #   The pointer segment.
      #
      def segment
        self[:segment]
      end

      alias seg segment

      #
      # Returns the offset within the segment of the pointer.
      #
      # @return [Integer]
      #   The offset within the segment.
      #
      def offset
        self[:offset]
      end

      alias off offset

    end
  end
end
