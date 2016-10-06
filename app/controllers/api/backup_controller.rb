class Api::BackupController < ApplicationController
  protect_from_forgery with: :null_session
  include ApplicationHelper
  
  # update path_include or path_exclude
  def update
    dotype = params[:type]
    path = params[:path]
    
    backup = Backup.find_by_id(params[:id])
    if(backup.present?)
      if(dotype == "in")
        backup.update_path_include(path)  # for include path
      else
        backup.update_path_exclude(path)  # for exclude path
      end
    end
    
    render plain: "Ok"
    
  end
  
  
  def show 
    backup = Backup.find_by_id(params[:id])
    render json: {path: backup.path_contents}, status: 200
  end
end