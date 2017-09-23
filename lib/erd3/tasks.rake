require 'rails-erd'
spec = Gem::Specification.find_by_name 'rails-erd'
load "#{spec.gem_dir}/lib/rails_erd/tasks.rake"

namespace :erd3 do
  task :generate => ['erd:check_dependencies', 'erd:options', 'erd:load_models'] do
    Erd3::Circle.new.create
  end
end

task :erd3 => "erd3:generate"
