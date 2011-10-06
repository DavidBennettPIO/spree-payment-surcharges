PaymentMethod.class_eval do
  
  #ObjectSpace.each_object(Module) do |m|
  #  if m.ancestors.include? self && m != PaymentMethod && m != Gateway
  #    m.class_eval do
  #      calculated_adjustments
  #    end
  #    m.regi#ster_calculator(Calculator::FlatRate)
  #    m.register_calculator(Calculator::FlatPercentItemTotal)
  #  end
  #end
  
  calculated_adjustments
  
  PaymentMethod.register_calculator(Calculator::FlatRate)
  PaymentMethod.register_calculator(Calculator::FlatPercentItemTotal)
  PaymentMethod.register_calculator(Calculator::FlatPercentPayable)

end

