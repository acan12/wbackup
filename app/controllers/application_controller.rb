class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception, prepend: true
  include LocalAssetsPipeline
  
  def current_profile
    "DUMMY_PROFILE" unless params[:profile].present?
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
  
  def backup_filename(version)
    # "WB__{profile_name}__v{version}" 
    return AppConfig::backup_name_pattern
      .gsub(/{uid}/i, current_user.id.to_s)
      .gsub(/{profile_name}/i, current_profile)
      .gsub(/{version}/i, version.to_s)
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
    vno = filename.split(/__/i)[4].scan(/\d+/i)[0]
    return vno
  end
  
  def get_backup_created(filename)
    date = filename.split(/__/i)[3]
    DateTime.parse(date)
  end
end
