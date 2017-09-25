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
              TYPE => dest.model.source_dir
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
                TYPE => model.source_dir
              }
            }
          )
        end

      data.each do |name, name_deps_type|
        name_deps_type[DEPENDED_ON_BY] =
          data.select{ |_, _name_deps_type| _name_deps_type[DEPENDS].include?(name) }.keys
        name_deps_type[DOCS] = docs(name)
      end

      @data = data
    end

    def docs klass_name
      sub_template('doc').result(binding)
    end

  end
end
