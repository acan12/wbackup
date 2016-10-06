class Backup < ApplicationRecord
  belongs_to :user
  
  attr_accessor :path_draft_contents
  
  def update_path_include(path)
    self.update(path_draft: (path_draft_contents << path).join("__")) unless path_draft_contents.include?(path)
  end
  
  def update_path_exclude(path)
  
    paths = path_draft_contents - [path]
    self.update(path_draft: paths.join("__"))
  end
  
  def path_draft_contents
    self.path_draft.to_s.split("__")
  end
end