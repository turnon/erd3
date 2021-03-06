class ActiveRecord::Base
  class << self
    attr_accessor :source_location

    def source_dir
      @source_dir ||= (source_location ? File.dirname(source_location) : 'unknown')
    end
  end
end
