class DashboardController < ApplicationController
  include ApplicationHelper
  set_local_assets_pipeline! jss: true, css: true
  before_action :authenticate_user!, only: [:index]
  
  
  def index
    @data = Dir.glob("#{current_path}/*").map{|f| 
        unless filedirname(f).eql?(AppConfig::backup_root_name)
          { path: f,
            name: filedirname(f), 
            dirtype: File.directory?(f),
            ctime: File.lstat(f).ctime,
            mtime: File.lstat(f).mtime,
            atime: File.lstat(f).atime,                    
            size: File.lstat(f).size,
            mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
            permission: (File.lstat(f).mode & 0777) } 
          end
      }.compact.sort_by {|k,v| v }.reverse 
      
    @backup = Dir.glob("#{AppConfig::backup_destination_path}/*").map{|f| 
      if is_current_user_owner?(filedirname(f))
          { path: f,
            name: get_backup_profile(filedirname(f)), 
            mtime: File.lstat(f).mtime,
            size: File.lstat(f).size,
            version: get_backup_version(filedirname(f)) } 
      end
    }.compact.sort_by {|k,v| v }.reverse
    
    @backup_profiles = current_user.backups
    
  end
  
  def create
    profile_name = params[:profile_name]
    backup = Backup.create(name: profile_name, user_id: current_user.id)
    
    redirect_to root_path(profile: backup.id)
  end
  
  
  
end