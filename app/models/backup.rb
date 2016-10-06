class Backup < ApplicationRecord
  belongs_to :user
  
  attr_accessor :path_contents
  
  def update_path_include(path)
    self.update(path: (path_contents << path).join("__")) unless path_contents.include?(path)
  end
  
  def update_path_exclude(path)
  
    paths = path_contents - [path]
    self.update(path: paths.join("__"))
  end
  
  def path_contents
    self.path.to_s.split("__")
  end
end