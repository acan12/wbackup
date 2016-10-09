class Archieve < ApplicationRecord
  
  def path_archieve_contents
    self.path.to_s.split("__")
  end
  
end
