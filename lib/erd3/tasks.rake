require 'rails-erd'
spec = Gem::Specification.find_by_name 'rails-erd'
load "#{spec.gem_dir}/lib/rails_erd/tasks.rake"

namespace :erd3 do
  task :patch do
    Dir.glob(File.join(__dir__, '..', 'patch', '*')).each do |patch|
      require patch
    end
  end

  task :generate => ['patch', 'erd:options', 'erd:load_models'] do
    Erd3::Types::Force.new.create
    Erd3::Types::Circle.new.create
  end
end

task :erd3 => "erd3:generate"
