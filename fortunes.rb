module Fortunes
  FOLDER="fortunes"

  def count
    Dir.entries(FOLDER).size
  end
  
  module_function :count
end
