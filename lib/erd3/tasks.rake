require 'rails-erd'
spec = Gem::Specification.find_by_name 'rails-erd'
load "#{spec.gem_dir}/lib/rails_erd/tasks.rake"

namespace :erd3 do
  task :generate => ['erd:check_dependencies', 'erd:options', 'erd:load_models'] do

    require "rails_erd/domain"
    domain = RailsERD::Domain.generate
    domain.relationships.each do |relationship|
      line = if relationship.indirect? then "-.-" else "-" end
      arrow =
        case
        when relationship.one_to_one?   then "1#{line}1>"
        when relationship.one_to_many?  then "1#{line}*>"
        when relationship.many_to_many? then "*#{line}*>"
        end
      puts "[#{relationship.source}] #{arrow} [#{relationship.destination}]"
    end

  end
end

task :erd3 => "erd3:generate"
