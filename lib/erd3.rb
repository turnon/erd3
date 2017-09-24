require "erd3/version"
require "erd3/base"
require "erd3/abstract_reflection"
require "erd3/railtie" if defined? Rails
require "rails_erd/domain"
require "erb"

Dir.glob(File.join(__dir__, 'types', '*')).each do |path|
  require path
end

Erd3::Types.constants.each do |klass_name|
  Erd3::Types.const_get(klass_name).include Erd3::Base
end
