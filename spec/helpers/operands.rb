require 'udis86/ud'

require 'spec_helper'
require 'helpers/files'

module Helpers
  def ud_operands(name)
    ud_file(name) do |ud|
      ud.next_insn

      return ud.operands
    end
  end
end
