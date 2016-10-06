module ApplicationHelper
  
  def current_path
    params[:p] ||= ""
  end
  
  def current_profile
    params[:b] ||= ""
  end
  
  def filedirname(w)
    w.split("/").last
  end
  
end
