class DashboardController < ApplicationController
  include ApplicationHelper
  set_local_assets_pipeline! jss: true, css: true
  before_action :authenticate_user!, only: [:index]
  
  # browse your files directory
  def index
    backup = Backup.find_by_id(params[:b])
    # @data = Dir.glob("#{current_path}/*").map{|f| 
    #     unless filedirname(f).eql?(AppConfig::backup_root_name)
    #       { 
    #         active: (backup.present? && backup.path_draft_contents.include?(f)) ? "active" : "",
    #         path: f,
    #         name: filedirname(f), 
    #         dirtype: File.directory?(f),
    #         ctime: File.lstat(f).ctime,
    #         mtime: File.lstat(f).mtime,
    #         atime: File.lstat(f).atime,       
    #         btime: File.lstat(f).birthtime,             
    #         size: "10"Backup.dir_size(f), #File.lstat(f).size,
    #         mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
    #         permission: (File.lstat(f).mode & 0777) } 
    #       end
    #   }.compact.sort_by {|k,v| v }.reverse 
      
    @backup = Dir.glob("#{AppConfig::backup_destination_path}*").map{|f| 
      if is_current_user_owner?(filedirname(f))
          { id: get_backup_id_from_filename(f),
            path: f,
            name: get_backup_profile(filedirname(f)), 
            mtime: File.lstat(f).ctime,
            start: Backup.find(get_backup_id_from_filename(f)).start_process,
            end: Backup.find(get_backup_id_from_filename(f)).end_process,            
            # size: File.lstat(f).size,
            size: Backup.dir_size(f),
            version: get_backup_version(filedirname(f)) } 
      end
    }.compact.sort_by {|k,v| v }.reverse
    
    @backup_profiles = current_user.backups
    
  end
  
  # create your backup profile or name
  def create
    profile_name = params[:profile_name]
    backup = Backup.create(name: profile_name, user_id: current_user.id)
    
    redirect_to root_path(b: backup.id)
  end
  
  
  
end