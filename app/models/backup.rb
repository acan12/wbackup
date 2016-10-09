class Backup < ApplicationRecord
  belongs_to :user
  
  
  attr_accessor :path_draft_contents
  attr_accessor :path_backup_contents  
  
  def update_path_include(path)
    self.update(path_draft: (path_draft_contents << path).join("__")) unless path_draft_contents.include?(path)
  end
  
  def update_path_exclude(path)
  
    paths = path_draft_contentss - [path]
    self.update(path_draft: paths.join("__"))
  end
  
  def path_draft_contents
    self.path_draft.to_s.split("__")
  end
  
  def path_backup_contents
    self.path_backup.to_s.split("__")
  end
  
  
  
## static methods

  # counting size of directory / file
  def self.dir_size(dir_path)
    require 'find'
    size = 0
    Find.find(dir_path) { |f| 
      size += File.size(f) if File.file?(f) 
      break if size > 500000 #000000
    }

    size
  end
  
  # everytime do backup always updated the backup and create archieve 
  def self.doBackup(backup, backup_file_name, backup_file_name_with_version)
    dst = AppConfig::backup_destination_path + backup_file_name_with_version
    FileUtils.mkdir_p(dst)
    
    start = DateTime.now
    backup.path_draft_contents.each do |f|
      dirfile = File.directory?(f) ? f+"/" : f
      FileUtils.cp_r(Dir.glob("#{dirfile}"), dst)
    end
    path = backup.path_draft_contents.join("__")
    backup.update(
        backup_file_name: backup_file_name,
        path_draft: "", 
        path_backup: backup.path_draft_contents.join("__"), 
        version: backup.version+1,
        start_process: start,
        end_process: DateTime.now)
        
        
    Archieve.create(
              name: backup.name,
              backup_file_name: backup_file_name, 
              path: path,
              start_process: backup.start_process,
              end_process: backup.end_process,
              version: backup.version, 
              stat_total_size: backup.stat_total_size,
              stat_top_files_changed: backup.stat_top_files_changed)
        
    return dst
  end
  
  
  
  def self.doRestore(backup, backup_file_name, backup_file_name_with_version, version)
    
    src = AppConfig::backup_destination_path + backup_file_name_with_version
    # /Wbox/WB2__u1__B2016__v1/
    backup_files = Dir.glob("#{src}/*")
    
    # mechanism when restoring all backup to original path
    archieve = Archieve.find_by(backup_file_name: backup.backup_file_name, version: version)
    archieve.path_archieve_contents.each do |o|
      
      file = backup_files.map{|x| 
        x if File.basename(x) == File.basename(o)
      }.compact.last

      target = File.directory?(File.dirname(o)) ? File.dirname(o) : File.dirname(o)

      FileUtils.cp_r(file, target)
    end

    # mechanism archieving when restore the backup
    archieves = Archieve.where(backup_file_name: backup_file_name)
    if archieves.size == 1 # if just only 1 , backup + archieve will delete  
      backup.delete  # delete backup after restore done
      archieves.find_by_version(version).delete
      
    elsif archieves.size > 1 # archieve with version restore will deleted and get latest version of archieve
      array = archieves.map{|arc| 
        if arc.version.to_s == version
          arc.delete 
          nil
        else
          arc.version
        end
      }.compact
      
      # updated data path and version from archieve to backup , make sure backup get the latest version of archieve
      path_backup = archieves.where(version: array.sort.last).last.path
      backup.update(path_backup: path_backup, version: array.sort.last)
    end
    
    # remove backup files from backup root path
    FileUtils.rm_rf(src)
  end
  
  
  
  
end