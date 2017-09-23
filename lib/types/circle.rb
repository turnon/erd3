module Erd3::Types
  class Circle

    NAME = "name".freeze
    IMPORTS = "imports".freeze

    def calculate
      dests = domain.relationships.group_by(&:destination).map do |dest, srcs|
        {NAME => dest.model.to_s, IMPORTS => srcs.map{ |s| s.source.model.to_s }}
      end

      no_srcs = models_without_src.map do |model|
        {NAME => model.to_s, IMPORTS => []}
      end

      @data = (dests + no_srcs).sort_by{ |h| h[NAME] }
    end

  end
end
