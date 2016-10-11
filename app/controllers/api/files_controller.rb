class Api::FilesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
    
  def index
    current_path = params[:path]
    backup = Backup.find_by_id(params[:b])
    @data = Dir.glob("#{current_path}/*").map{|f| 
        unless filedirname(f).eql?(AppConfig::backup_root_name)
          { active: (backup.present? && backup.path_draft_contents.include?(f)) ? "active" : "",
            path: f,
            name: filedirname(f), 
            dirtype: File.directory?(f),
            ctime: File.lstat(f).ctime,
            mtime: File.lstat(f).mtime,
            atime: File.lstat(f).atime,    
            btime: File.lstat(f).birthtime,                             
            size: number_to_human_size(Backup.dir_size(f)),
            mtype: (  File.directory?(f) && MIME::Types.type_for(filedirname(f)).blank? ) ? "-" : MIME::Types.type_for(filedirname(f)).try(:first).try(:content_type),
            permission: (File.lstat(f).mode & 0777) } 
          end
      }.compact.sort_by {|k,v| v }.reverse
      
      render json: @data
  end
end