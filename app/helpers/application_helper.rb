module ApplicationHelper
  
  def current_path
    params[:p] ||= ""
  end
  
  def filedirname(w)
    w.split("/").last
  end
  
end
