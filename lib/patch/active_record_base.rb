class ActiveRecord::Base
  class << self
    attr_accessor :source_location, :model_validity

    def source_dir
      @source_dir ||= (source_location ? File.dirname(source_location) : 'unknown')
    end

    def human_attribute_names
      attribute_names.each_with_object({}){ |attr, h| h[attr] = human_attribute_name(attr) }
    end
  end
end
