module Erd3
  class Railtie < Rails::Railtie
    rake_tasks do
      load "erd3/tasks.rake"
    end
  end
end
