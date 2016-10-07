class Backup < ApplicationRecord
  belongs_to :user
  
  validates_uniqueness_of :name
  
  attr_accessor :path_draft_contents
  attr_accessor :path_backup_contents  
  
  def update_path_include(path)
    self.update(path_draft: (path_draft_contents << path).join("__")) unless path_draft_contents.include?(path)
  end
  
  def update_path_exclude(path)
  
    paths = path_draft_contents - [path]
    self.update(path_draft: paths.join("__"))
  end
  
  def path_draft_contents
    self.path_draft.to_s.split("__")
  end
  
  def path_backup_contents
    self.path_backup.to_s.split("__")
  end
  
  
  
## static methods
  
  def self.doBackup(backup, backup_file_name, backup_file_name_with_version)
    dst = AppConfig::backup_destination_path + backup_file_name_with_version
    FileUtils.mkdir_p(dst)
    
    start = DateTime.now
    backup.path_draft_contents.each do |f|
      FileUtils.cp_r(Dir.glob("#{f}*"), dst)
    end
    backup.update(
        path_draft: "", 
        path_backup: backup.path_draft_contents.join("__"), 
        latest_version: backup.latest_version+1,
        start_process: start,
        end_process: DateTime.now)
        
    Archieve.create(
              backup_file_name: backup_file_name, 
              path: backup.path_backup,
              start_process: backup.start_process,
              end_process: backup.end_process,
              version: backup.latest_version, 
              stat_total_size: backup.stat_total_size,
              stat_top_files_changed: backup.stat_top_files_changed)
        
    return dst
  end
  
  
  
  def self.doRestore(backup, backup_file_name, backup_file_name_with_version)
    
    src = AppConfig::backup_destination_path + backup_file_name_with_version
    # /Wbox/WB2__u1__B2016__v1/
    # /Users/arysuryawan/weka.log
    backup_files = Dir.glob("#{src}/*")
    backup.path_backup_contents.each do |o|
      
      file = backup_files.map{|x| 
        x if File.basename(x) == File.basename(o)
      }.compact.last
      
      target = File.directory?(File.dirname(o)) ? File.dirname(o) : File.dirname(o)
      FileUtils.cp_r(file, target)
    end
    
    version = backup.latest_version
    if version == 1
      backup.delete  # delete backup after restore done
      Archieve.find_by(backup_file_name: backup_file_name, version: version).delete
    else
      Archieve.find_by(backup_file_name: backup_file_name, version: version).delete
      backup.update(latest_version: backup.latest_version - 1)
    end
    


    FileUtils.rm_rf(src)
  end
end