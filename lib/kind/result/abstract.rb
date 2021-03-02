# frozen_string_literal: true

module Kind
  module Result::Abstract
    def failure?
      false
    end

    def failed?
      failure?
    end

    def success?
      false
    end

    def succeeded?
      success?
    end

    def on(&block)
      raise NotImplementedError
    end

    def on_success(types = Undefined, matcher = Undefined)
      raise NotImplementedError
    end

    def on_failure(types = Undefined, matcher = Undefined)
      raise NotImplementedError
    end

    def result?(types, matcher)
      undef_t = Undefined == (t = types)
      undef_m = Undefined == (m = matcher)

      return true if undef_t && undef_m

      if !undef_t && undef_m && !(Array === types || Symbol === types)
        m, t = types, matcher

        undef_m, undef_t = false, true
      end

      is_type = undef_t || (::Array === t ? t.empty? || t.include?(type) : t == type)
      is_type && (undef_m || m === value)
    end

    def to_ary
      [type, value]
    end
  end
end
