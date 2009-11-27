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

      #
      # The signed byte value of the operand.
      #
      # @return [Integer]
      #   The signed byte value.
      #
      def sbyte
        self[:sbyte]
      end

      alias char sbyte
      alias signed_byte sbyte

      #
      # The unsigned byte value of the operand.
      #
      # @return [Integer]
      #   The unsigned byte value.
      #
      def ubyte
        self[:ubyte]
      end

      alias byte ubyte
      alias unsigned_byte ubyte

      #
      # The signed word value of the operand.
      #
      # @return [Integer]
      #   The signed word value.
      #
      def sword
        self[:sword]
      end

      alias signed_word sword

      #
      # The unsigned word value of the operand.
      #
      # @return [Integer]
      #   The unsigned word value.
      #
      def uword
        self[:uword]
      end

      alias word uword
      alias unsigned_word uword

      #
      # The signed double-word value of the operand.
      #
      # @return [Integer]
      #   The signed double-word value.
      #
      def sdword
        self[:sdword]
      end

      alias signed_double_word sdword

      #
      # The unsigned double-word value of the operand.
      #
      # @return [Integer]
      #   The unsigned double-word value.
      #
      def udword
        self[:udword]
      end

      alias double_word udword
      alias unsigned_double_word udword

      #
      # The signed quad-word value of the operand.
      #
      # @return [Integer]
      #   The signed quad-word value.
      #
      def sqword
        self[:sqword]
      end

      alias signed_quad_word sqword

      #
      # The unsigned quad-word value of the operand.
      #
      # @return [Integer]
      #   The unsigned quad-word value.
      #
      def uqword
        self[:uqword]
      end

      alias quad_word uqword
      alias unsigned_quad_word uqword

      #
      # The pointer value of the operand.
      #
      # @return [OperandPointer]
      #   The pointer value.
      #
      def ptr
        self[:ptr]
      end

      alias pointer ptr

    end
  end
end
