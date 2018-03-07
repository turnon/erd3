module RailsERD
  class Domain
    alias_method :o_check_model_validity, :check_model_validity
    alias_method :o_warn, :warn

    def check_model_validity(model)
      Thread.current[:warn_buffer] = nil
      o_check_model_validity model
      model.model_validity = Thread.current[:warn_buffer]
      true
    end

    def warn(message)
      Thread.current[:warn_buffer] = message
      o_warn message
    end
  end
end
