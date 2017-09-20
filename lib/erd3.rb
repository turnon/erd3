require "erd3/version"
require "erd3/railtie" if defined? Rails
require "rails_erd/domain"
require "erb"

module Erd3
  class Circle

    NAME = "name".freeze
    IMPORTS = "imports".freeze

    class << self
      def create
        File.open(output_file, 'w') do |f|
          f.puts ERB.new(File.read(template_file)).result(binding)
        end
      end

      def data
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

        data = (dests + no_srcs).sort_by{ |h| h[NAME] }
      end

      def template_file
        File.join __dir__, 'templates', 'circle.erb'
      end

      def output_file
        File.join Rails.root.to_s, 'circle.html'
      end
    end

  end
end
