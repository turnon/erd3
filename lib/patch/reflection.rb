module ActiveRecord::Reflection

  module StringifiedDefinition
    def stringified_definition
      "#{macro} :#{name}#{refl_opts_str}"
    end

    private

    def refl_opts_str
      return "" if options.blank?
      ", " + options.map{ |k, v| "#{k}: #{v}" }.join(", ")
    end
  end

  [MacroReflection, ThroughReflection].each do |ref|
    ref.include StringifiedDefinition
    ref.send :attr_accessor, :association_validity
  end

end
