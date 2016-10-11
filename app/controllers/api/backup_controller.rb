class Api::BackupController < ApplicationController
  protect_from_forgery with: :null_session
  include ApplicationHelper
  
  
  # create backup
  def create
    bid = params[:bid]
    backup = Backup.find(bid)
    filename = backup_filename(backup.id, backup.name)
    filename_with_version = backup_filename_with_version(filename, backup.version + 1)
    
    destination = Backup.doBackup(backup, filename, filename_with_version)
    
    render json: {id: 0, link: backup_url(id: 0, p: destination, b: bid, v: backup.version)}, status: 200
  end
  
  
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
  
  def stats
    option = params[:opt]
    array = []
    if option == "ftype"
      
    else
      Dir.glob("#{AppConfig::backup_destination_path}*").map{|f| 
        size = Backup.dir_size(f)
        mb_available = size  
        fname = get_backup_profile(f)+" Version-"+get_backup_version(f)
        array << { name: fname, size: mb_available}
      }
    end
    

    render json: array.to_json, status: 200
    
  end
  
end