class ActiveRecord::Reflection::MacroReflection
  def stringified_definition
    "#{macro} :#{name}#{refl_opts_str}"
  end

  private

  def refl_opts_str
    return "" if options.blank?
    ", " + options.map{ |k, v| "#{k}: #{v}" }.join(", ")
  end
end
