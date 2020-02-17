require 'ffi/udis86/operand_value'
require 'ffi/udis86/types'

require 'ffi'

module FFI
  module UDis86
    class Operand < FFI::Struct

      layout :type, :ud_type,
             :size, :uint16,
             :base, :ud_type,
             :index, :ud_type,
             :scale, :uint8,
             :offset, :uint8,
             :value, OperandValue,
             :_legacy, :uint64, # this will be removed in libudis86 1.8
             :_oprcode, :uint8

      #
      # The type of the operand.
      #
      # @return [Symbol]
      #   The type of the operand.
      #
      def type
        self[:type]
      end

      #
      # Determines if the operand is a memory access.
      #
      # @return [Boolean]
      #   Specifies whether the operand is a memory access.
      #
      def is_mem?
        self[:type] == :ud_op_mem
      end

      #
      # Determines if the operand is Segment:Offset pointer.
      #
      # @return [Boolean]
      #   Specifies whether the operand is Segment:Offset pointer.
      #
      def is_seg_ptr?
        self[:type] == :ud_op_ptr
      end

      #
      # Determines if the operand is immediate data.
      #
      # @return [Boolean]
      #   Specifies whether the operand is immediate data.
      #
      def is_imm?
        self[:type] == :ud_op_imm
      end

      #
      # Determines if the operand is a relative offset used in a jump.
      #
      # @return [Boolean]
      #   Specifies whether the operand is a relative offset.
      #
      def is_jmp_imm?
        self[:type] == :ud_op_jimm
      end

      #
      # Determines if the operand is a data constant.
      #
      # @return [Boolean]
      #   Specifies whether the operand is a data constant.
      #
      def is_const?
        self[:type] == :ud_op_const
      end

      #
      # Determines if the operand is a register.
      #
      # @return [Boolean]
      #   Specifies whether the operand is a register.
      #
      def is_reg?
        self[:type] == :ud_op_reg
      end

      #
      # The size of the operand.
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
          return self[:value].ptr
        when :ud_op_reg
          return nil
        else
          return self[:value]
        end
      end

      #
      # The base register used by the operand.
      #
      # @return [Symbol]
      #   The base register of the operand.
      #
      def base
        REGS[self[:base]]
      end

      alias reg base

      #
      # The index register used by the operand.
      #
      # @return [Symbol]
      #   The index register of the operand.
      #
      def index
        REGS[self[:index]]
      end

      #
      # The offset value used by the operand.
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
      # The word-length of the offset used with the operand.
      #
      # @return [Integer]
      #   Word-length of the offset being used.
      #
      def offset_size
        self[:offset]
      end

      #
      # The scale value used by the operand.
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
