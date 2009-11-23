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

      def sbyte
        self[:sbyte]
      end

      alias signed_byte sbyte

      def ubyte
        self[:ubyte]
      end

      alias unsigned_byte ubyte

      def sword
        self[:sword]
      end

      alias signed_word sword

      def uword
        self[:uword]
      end

      alias unsigned_word uword

      def sdword
        self[:sdword]
      end

      alias signed_double_word sdword

      def udword
        self[:udword]
      end

      alias unsigned_double_word udword

      def sqword
        self[:sqword]
      end

      alias signed_quad_word sqword

      def uqword
        self[:uqword]
      end

      alias unsigned_quad_word uqword

      def ptr
        self[:ptr]
      end

      alias pointer ptr

    end
  end
end
