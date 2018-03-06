require 'rails-erd'
spec = Gem::Specification.find_by_name 'rails-erd'
load "#{spec.gem_dir}/lib/rails_erd/tasks.rake"

namespace :erd3 do
  task :patch do
    Dir.glob(File.join(__dir__, '..', 'patch', '*')).each do |patch|
      require patch
    end
  end

  task :assign_source_location do
    ActiveRecord::Base.descendants.each do |klass|
      klass.source_location = ActiveSupport::Dependencies.loaded_model_paths[klass.name.underscore]
    end
  end

  task :generate => ['patch', 'erd:options', 'erd:load_models', 'assign_source_location'] do
    Erd3::Types::Zforce.new.create
    #Erd3::Types::Force.new.create
    Erd3::Types::Circle.new.create
  end
end

task :erd3 => "erd3:generate"
