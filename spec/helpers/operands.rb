require 'udis86/ud'

require 'helpers/files'

module Helpers
  def ud_operands(file)
    ud = ud_file(file)
    ud.next_insn

    return ud.operands
  end
end
