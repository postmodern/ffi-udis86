require 'udis86/operand_value'
require 'udis86/types'

require 'ffi'

module FFI
  module UDis86
    class Operand < FFI::Struct

      layout :type, :ud_type,
             :size, :uint8,
             :value, OperandValue,
             :base, :ud_type,
             :index, :ud_type,
             :offset, :uint8,
             :scale, :uint8

      #
      # Returns the type of the operand.
      #
      # @return [Integer]
      #   The type of the operand.
      #
      def type
        self[:type]
      end

      #
      # Returns the size of the operand.
      #
      # @return [Integer]
      #   The size of the operand in bytes.
      #
      def size
        self[:size]
      end

      #
      # The value of the operand.
      #
      # @return [OperandValue, OperandPointer]
      #   The value of the operand. If the operand represents a pointer,
      #   an OperandPointer object will be returned.
      #
      def value
        case type
        when :ud_op_ptr
          self[:value].ptr
        else
          self[:value]
        end
      end

      #
      # Returns the base address used by the operand.
      #
      # @return [Integer]
      #   The base address of the operand.
      #
      def base
        REGS[self[:base]]
      end

      #
      # Returns the index value used by the operand.
      #
      # @return [Integer]
      #   The index value of the operand.
      #
      def index
        REGS[self[:index]]
      end

      #
      # Returns the offset value used by the operand.
      #
      # @return [OperandValue, 0]
      #   The offset value of the operand.
      #
      def offset
        if self[:offset] > 0
          return self[:value]
        else
          return 0
        end
      end

      #
      # Returns the word-length of the offset used with the operand.
      #
      # @return [Integer]
      #   Word-length of the offset being used.
      #
      def offset_size
        self[:offset]
      end

      #
      # Returns the scale value used by the operand.
      #
      # @return [Integer]
      #   The scale value of the operand.
      #
      def scale
        self[:scale]
      end

      #
      # Returns the register name of the operand.
      #
      # @return [Symbol, nil]
      #   Returns the register name as a Symbol, or +nil+ if the operand
      #   is not a register.
      #
      def reg
        REGS[type]
      end

    end
  end
end
