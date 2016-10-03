class BackupController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:create, :show]
  
  
  def create
    src     = params[:path]
    
    dst = AppConfig::backup_destination_path + backup_filename(1)
    FileUtils.mkdir_p(dst)
    FileUtils.cp_r(Dir.glob("#{src}*"), dst)
    
    redirect_to backup_path(id: 0, p: dst)
  end
  
  def show
    @data = Dir.glob("#{params[:p]}/*").map{|f| 
        { path: f,
          name: filedirname(f), 
          dirtype: File.directory?(f),
          ctime: File.lstat(f).ctime,
          mtime: File.lstat(f).mtime,
          atime: File.lstat(f).atime,                    
          size: File.lstat(f).size,
          mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
          permission: (File.lstat(f).mode & 0777) } 
      }.sort_by {|k,v| v }.reverse
  end
end