class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception, prepend: true
  include LocalAssetsPipeline
  
  def current_profile
    session[:current_profile] ||= params[:profile]
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  
  def backup_filename(backup_id, profile)
    # "WB__{profile_name}__v{version}" 
    return AppConfig::backup_name_pattern
      .gsub(/{bid}/i, backup_id.to_s)
      .gsub(/{uid}/i, current_user.id.to_s)
      .gsub(/{profile_name}/i, profile)
  end
  
  def backup_filename_with_version(backup_filename, version)
    # "WB__{profile_name}__v{version}" 
    return backup_filename+"__"+version.to_s
  end
  
  protected
  
  def get_backup_profile(filename)
    filename.split(/__/i)[2]
  end
  
  def is_current_user_owner?(filename)
    uid = filename.split(/__/i)[1].scan(/\d+/i)[0].to_i
    return current_user.id.eql?(uid)
  end
  
  def get_backup_version(filename)
    vno = filename.split(/__/i)[3].scan(/\d+/i)[0]
    return vno
  end
  
  def get_backup_id_from_filename(filename)
    return filename.split(/__/i)[0].split(/[a-z]/i).last
  end
  
end
