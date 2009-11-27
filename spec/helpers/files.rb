require 'udis86/ud'

require 'spec_helper'

module Helpers
  FILES_DIR = File.expand_path(File.join(File.dirname(__FILE__),'files'))

  def ud_file(name,&block)
    UD.open(File.join(FILES_DIR,"#{name}.o"),&block)
  end
end
