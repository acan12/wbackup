module ApplicationHelper
  
  def current_path
    params[:p] ||= "/"
  end
  
  def filedirname(w)
    w.scan(/[\w-]+/i).last
  end
end
