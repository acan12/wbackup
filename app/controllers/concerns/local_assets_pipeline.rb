module LocalAssetsPipeline extend ActiveSupport::Concern

  module ClassMethods
    def set_local_assets_pipeline!(options = nil)
      append_before_filter {local_assets_pipeline(options)}
    end
  end
  
  
  def local_assets_pipeline(options)
    option = (options ||= false)
    @jss_local_pipeline = option[:jss]
    @css_local_pipeline = option[:css]
  end

end