module Erd3
  module Base

    attr_reader :domain

    def initialize
      @domain = RailsERD::Domain.generate
    end

    def create
      calculate
      write
    end

    def models_with_src
      @models_with_src ||= domain.relationships.map{ |r| r.destination.model }.uniq!
    end

    def models_without_src
      @models_without_src ||=
        domain.entities.reduce([]) do |rs, e|
          rs << e.model if e.model != ApplicationRecord && !models_with_src.include?(e.model)
          rs
        end
    end

    def definitions
      @definitions ||= (
        collection = Hash.new{ |h, k| h[k] = Hash.new{ |h, k| h[k] = [] } }
        domain.relationships.each_with_object(collection) do |rel, coll|
          rel.associations.each do |reflection|
            coll[reflection.active_record.to_s][reflection.macro.to_s] << reflection
          end
        end
      )
    end

    def file_name
      @file_name ||= "#{self.class.to_s.sub(/.*::/, '').gsub(/(.)([A-Z])/, '\1_\2').downcase}"
    end

    def sub_template name
      (@sub_templates ||= {})[name] ||= (
        path = File.join __dir__, '..', 'templates', file_name, "#{name}.erb"
        ERB.new(File.read(path))
      )
    end

    private

    def write
      File.open(output_path, 'w') do |f|
        f.puts ERB.new(File.read(template_path)).result(binding)
      end
    end

    def template_path
      File.join __dir__, '..', 'templates', "#{file_name}.erb"
    end

    def output_path
      File.join Rails.root.to_s, "#{file_name}.html"
    end

  end
end
