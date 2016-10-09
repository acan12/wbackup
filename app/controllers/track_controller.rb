class TrackController < ApplicationController
  def show
    version   = params[:v]
    fpath1    = params[:p]
    fname     = File.basename(fpath1)
    
    backup  = Backup.find_by_id(params[:b])
    archieves = Archieve.where("name = ? AND version < ?", backup.name, params[:v].to_i).order("version DESC")
    prev_archieve = archieves.last
    
    
    begin
      fpath2 = fpath1.gsub(/__#{version}\//i, "__#{prev_archieve.version}/")  #AppConfig::backup_destination_path+prev_archieve.backup_file_name+"__#{prev_archieve.version}"+
      f1 = File.open(fpath1).read
      f2 = File.open(fpath2).read
      @html = Diffy::Diff.new(f1, f2)
    rescue
    end


    

  end
end