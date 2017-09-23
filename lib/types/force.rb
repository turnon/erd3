module Erd3::Types
  class Force

    NAME = 'name'.freeze
    DEPENDS = 'depends'.freeze
    TYPE = 'type'.freeze

    def calculate
      dests =
        domain.relationships.group_by(&:destination).map do |dest, srcs|
          name = dest.model.to_s
          {
            name => {
              NAME => name,
              DEPENDS => srcs.map{ |s| s.source.model.to_s },
              TYPE => 'group0'
            }
          }
        end.reduce({}) do |rs, e|
          rs.merge! e
        end

      @data =
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
    end
  end
end
