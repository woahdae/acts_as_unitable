module ActsAsUnitable
  def self.parse_unitable_string(value)
    value =~ /^(.*) (\w.+)$/
    return string_fraction_to_decimal($1), $2
  end
  
  def self.string_fraction_to_decimal(string_fraction)
    eval string_fraction.gsub(" ","+").gsub(/([0-9]+\/[0-9]+)$/, "\\1.0")
  end
  
  def acts_as_unitable(*methods)
    methods.each do |method|
      define_method("#{method}_with_unit".to_sym) do
        unit_attr = "#{method}_unit".to_sym
        self[unit_attr].blank? ? self[method] : self[method].send(:to_unit, self[unit_attr])
      end

      define_method("#{method}_with_unit=".to_sym) do |value|
        if value.is_a?(String)
          amount, unit = ActsAsUnitable.parse_unitable_string(value)
        elsif value.respond_to?(:scalar) && value.units
          amount = value.scalar
          unit = value.units
        else
          amount = value
          unit = nil
        end

        self[method] = amount.to_f
        self["#{method}_unit".to_sym] = self.attributes["#{method}_unit"] || unit
      end
    end
  end
end

class ActiveRecord::Base
  extend ActsAsUnitable
end
