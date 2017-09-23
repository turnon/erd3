require "erd3/version"
require "erd3/railtie" if defined? Rails
require "rails_erd/domain"
require "erb"

module Erd3

  class Base

    attr_reader :domain

    def initialize
      @domain = RailsERD::Domain.generate
    end

    def create
      calculate
      write
    end

    private

    def write
      File.open(output_path, 'w') do |f|
        f.puts ERB.new(File.read(template_path)).result(binding)
      end
    end

    def template_path
      File.join __dir__, 'templates', "#{file_name}.erb"
    end

    def output_path
      File.join Rails.root.to_s, "#{file_name}.html"
    end

    def file_name
      @file_name ||= "#{self.class.to_s.sub(/.*::/, '').gsub(/(.)([A-Z])/, '\1_\2').downcase}"
    end
  end

  class Circle < Base

    NAME = "name".freeze
    IMPORTS = "imports".freeze

    def calculate
      domain = RailsERD::Domain.generate

      dests = domain.relationships.group_by(&:destination).map do |dest, srcs|
        {NAME => dest.model.to_s, IMPORTS => srcs.map{ |s| s.source.model.to_s }}
      end

      models_with_src = dests.map{ |h| h[NAME] }

      models_without_src = domain.entities.reduce([]) do |rs, e|
        model_name = e.model.to_s
        rs << model_name if e.model != ApplicationRecord && !models_with_src.include?(model_name)
        rs
      end

      no_srcs = models_without_src.map do |model|
        {NAME => model, IMPORTS => []}
      end

      @data = (dests + no_srcs).sort_by{ |h| h[NAME] }
    end

  end

  class Force < Base
  end
end
