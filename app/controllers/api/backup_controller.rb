class Api::BackupController < ApplicationController
  protect_from_forgery with: :null_session
  include ApplicationHelper
  
  # update path_include or path_exclude
  def update
    do_backup = params[:do]
    path = params[:path]
    
    backup = Backup.find_by_id(params[:id])

    if(backup.present?)

      if(do_backup.to_bool)
        backup.update_path_include(path)  # for include path
      else
        backup.update_path_exclude(path)  # for exclude path
      end
    end
    
    render plain: "Ok"
    
  end
  
  
  def show 
    backup = Backup.find_by_id(params[:id])
    json = backup.path_draft_contents.map{|f| {backup_id: backup.id, dirtype: File.directory?(f), path: f}}
    render json: json, status: 200
  end
end