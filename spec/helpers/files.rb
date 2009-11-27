require 'udis86/ud'

module Helpers
  FILES_DIR = File.expand_path(File.join(File.dirname(__FILE__),'files'))

  def ud_file(name)
    UD.open(File.join(FILES_DIR,"#{name}.o"))
  end
end
