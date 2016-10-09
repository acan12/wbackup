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
          size: Backup.dir_size(f),
          # size: File.lstat(f).size,
          # status: File.lstat(f).birthtime.eql?(File.lstat(f).mtime) ? 'new' : 'changed',
          status: track_file_changed_in_backup_history(@backup.id, f, params[:v]),
          mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
          permission: (File.lstat(f).mode & 0777),
          version: params[:v] } 
      }.sort_by {|k,v| v }.reverse
  end
  
  
  
  private 
  
  def track_file_changed_in_backup_history(bid, fpath1, version)


    begin
      backup  = Backup.find_by_id(bid)
      
      archieves = Archieve.where("name = ? AND version < ?", backup.name, params[:v].to_i).order("version DESC")
      prev_archieve = archieves.last

      is_change = false
      
      fpath2 = fpath1.gsub(/__#{version}\//i, "__#{prev_archieve.version}/")  #AppConfig::backup_destination_path+prev_archieve.backup_file_name+"__#{prev_archieve.version}"+
      f1 = File.open(fpath1).read
      f2 = File.open(fpath2).read
      

      is_change = (f2 != f1)
      
    rescue
      is_change = false
    end
    is_change ? "changed" : "new"
  end
end