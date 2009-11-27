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
        self[:base]
      end

      #
      # Returns the index value used by the operand.
      #
      # @return [Integer]
      #   The index value of the operand.
      #
      def index
        self[:index]
      end

      #
      # Returns the offset value used by the operand.
      #
      # @return [Integer]
      #   The offset value of the operand.
      #
      def offset
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

    end
  end
end
