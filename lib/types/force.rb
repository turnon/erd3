module Erd3::Types
  class Force

    NAME = 'name'.freeze
    DEPENDS = 'depends'.freeze
    DEPENDED_ON_BY = 'dependedOnBy'.freeze
    TYPE = 'type'.freeze
    DOCS = 'docs'.freeze

    def calculate
      dests =
        domain.relationships.group_by(&:destination).map do |dest, relations|
          name = dest.model.to_s
          {
            name => {
              NAME => name,
              DEPENDS => relations.map{ |rel| rel.source.model.to_s },
              TYPE => 'group0'
            }
          }
        end.reduce({}) do |rs, e|
          rs.merge! e
        end

      data =
        models_without_src.reduce(dests) do |rs, model|
          name = model.to_s
          dests.merge!(
            {
              name => {
                NAME => name,
                DEPENDS => [],
                TYPE => 'group0'
              }
            }
          )
        end

      data.each do |name, name_deps_type|
        name_deps_type[DEPENDED_ON_BY] =
          data.select{ |_, _name_deps_type| _name_deps_type[DEPENDS].include?(name) }.keys
        name_deps_type[DOCS] = definitions[name].to_s
      end

      @data = data
    end

  end
end
