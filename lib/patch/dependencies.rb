module ActiveSupport::Dependencies
  alias_method :o_require_or_load, :require_or_load

  def require_or_load file_name, *args
    if file_name.starts_with?(models_dir)
      loaded_model_paths[File.basename(file_name, '.rb')] = model_path(file_name)
    end
    o_require_or_load file_name, *args
  end

  def loaded_model_paths
    @loaded_model_paths ||= {}
  end

  private

  def model_path file_name
    @_start ||= (models_dir.length..-1)
    file_name.slice(@_start)
  end

  def models_dir
    @_models_dir ||= File.join Rails.root.to_s, 'app', 'models'
  end
end
