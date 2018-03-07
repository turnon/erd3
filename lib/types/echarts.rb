module Erd3::Types
  class Echarts

    NAME = 'name'.freeze
    KEYWORD = 'keyword'.freeze
    BASE = 'base'.freeze
    VALUE = 'value'.freeze
    SYMBOL = 'symbol'.freeze
    CATEGORY = 'category'.freeze
    SOURCE = 'source'.freeze
    TARGET = 'target'.freeze

    def calculate
      categories = source_dirs.map{ |d| {NAME => d, KEYWORD => {}, BASE => d} }

      nodes, orders = [], {}
      models.each_with_index do |m, i|
        nodes << ({
          NAME => m.to_s,
          VALUE => 1,
          SYMBOL => (m.model_validity ? 'triangle': 'circle'),
          CATEGORY => source_dirs.index(m.source_dir)
        })
        orders[m] = i
      end

      links = effective_relationships.map do |rel|
        {SOURCE => orders[rel.source.model], TARGET => orders[rel.destination.model]}
      end

      @legend = source_dirs
      @data = {'categories' => categories, 'nodes' => nodes, 'links' => links}
    end
  end
end
