class Api::FilesController < ApplicationController
  include ApplicationHelper
    
  def index
    current_path = params[:path]
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
      
      render json: @data
  end
end