module Parameters
  # We don't double splat here. This allows the user to pass an object containing
  # the `:name` parameter. See https://tinyurl.com/3d89bwka
  macro permit_json_params(name, params)
    struct {{ name.id }}
      include ::JSON::Serializable

      alias ParamTypes = {{ params.map { |k, v| v }.join(" | ").id }}
      alias AllowedParams = Hash(Symbol, ParamTypes | Nil)

      {% for key, value in params %}
        property {{ key.id }} : {{ value.id }}
      {% end %}

      def self.parse(data : IO | String) : AllowedParams
        from_json(data).to_h
      end

      def to_h : AllowedParams
        p = AllowedParams.new(nil)
        {% for key, value in params %}
          p[:{{ key.id }}] = @{{ key.id }}
        {% end %}
        p
      end
    end
  end

  # TODO
  # macro permit_form_params(name, params)
  # end
end
