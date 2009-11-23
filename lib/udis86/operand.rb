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


      def type
        self[:type]
      end

      def size
        self[:size]
      end

      def value
        self[:value[
      end

      def base
        self[:base]
      end

      def index
        self[:index]
      end

      def offset
        self[:offset]
      end

      def scale
        self[:scale]
      end

    end
  end
end
