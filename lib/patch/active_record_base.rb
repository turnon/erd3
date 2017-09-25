class ActiveRecord::Base
  class << self
    attr_accessor :source_location

    def source_dir
      @source_dir ||= File.dirname source_location
    end
  end
end
