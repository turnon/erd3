module Erd3::Types
  class Zforce
    def calculate
      @data = {"nodes" => [{"id" => "yzp","group" => 1},{"id" => "ken","group" => 2}],
               "links" => [{"source" => "yzp", "target" => "ken", "value" => 1}]}
    end
  end
end
