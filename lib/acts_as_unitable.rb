module Units
  module ActiveRecord
    def acts_as_unitable(*methods)
      methods.each do |method|
        define_method(method) do
          unit_attr = "#{method}_unit".to_sym
          self[unit_attr].blank? ? self[method] : self[method].send(self[unit_attr])
        end

        define_method("#{method}=".to_sym) do |value|
          if value.is_a?(String) && value =~ /^(.*?) (\w.*?)$/
            amount = $1
            unit = $2
          elsif value.respond_to?(:unit) && value.unit
            amount = value
            unit = value.unit
          else
            amount = value
            unit = nil
          end

          amount = amount.to_f
          amount = amount.send(unit) if unit

          self[method] = amount
          self["#{method}_unit".to_sym] = self.attributes["#{method}_unit"] || unit
        end
      end
    end
  end
end 
    
class ActiveRecord::Base
  extend Units::ActiveRecord
end
