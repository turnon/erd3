module Erd3::Types
  class Zforce

    ID = "id".freeze
    GROUP = "group".freeze
    SOURCE = "source".freeze
    TARGET = "target".freeze
    VALUE = "value".freeze

    def calculate
      nodes = models.map do |m|
        {ID => m.to_s, GROUP => source_dirs.index(m.source_dir)}
      end

      links = effective_relationships.map do |rel|
        {SOURCE => rel.source.model.to_s, TARGET => rel.destination.model.to_s, VALUE => 1}
      end

      @data = {"nodes" => nodes, "links" => links}
    end

  end
end
