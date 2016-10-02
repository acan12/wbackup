require 'mime-types'  


class DashboardController < ApplicationController
  include ApplicationHelper
  
  set_local_assets_pipeline! jss: true  
  before_action :authenticate_user!, only: [:index]
  
  def index
    @data = Dir.glob("#{current_path}*").map{|x| 
        { name: filedirname(x), 
          dirtype: File.directory?(x),
          mtime: File.lstat(x).mtime,
          ctime: File.lstat(x).ctime,
          # mtype: (File.directory?(x)) ? "-" : MIME::Types.type_for(x).first.content_type,
          permission: (File.lstat(x).mode & 0777) } 
      }.sort_by {|k,v| v }.reverse
    
  end
end