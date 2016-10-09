class BackupController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:create, :show]
  skip_before_action :verify_authenticity_token, only: [:create]
  
  
  # create backup
  def create
    bid = params[:backupid]
    backup = Backup.find(bid)
    filename = backup_filename(backup.id, backup.name)
    filename_with_version = backup_filename_with_version(filename, backup.version + 1)
    
    destination = Backup.doBackup(backup, filename, filename_with_version)
    
    redirect_to backup_path(id: 0, p: destination, b: bid, v: backup.version)
  end
  
  # restore from backup to original path
  def restore
    bid = params[:backupid]
    version = params[:version]    
    backup = Backup.find(bid)
    
    filename = backup_filename(backup.id, backup.name)
    filename_with_version = backup_filename_with_version(filename, version)

    Backup.doRestore(backup, filename, filename_with_version, version)
    
    redirect_to root_path
  end
  
  # browsing files in backup
  def show
    @backup = Backup.find(params[:b])
    @data = Dir.glob("#{params[:p]}/*").map{|f| 
        { id: @backup.id,
          path: f,
          name: filedirname(f), 
          dirtype: File.directory?(f),
          ctime: File.lstat(f).ctime,
          mtime: File.lstat(f).mtime,
          atime: File.lstat(f).atime,                    
          btime: File.lstat(f).birthtime,
          size: File.lstat(f).size,
          status: File.lstat(f).birthtime.eql?(File.lstat(f).mtime) ? 'new' : 'changed',
          mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
          permission: (File.lstat(f).mode & 0777),
          version: params[:v] } 
      }.sort_by {|k,v| v }.reverse
  end
end