Admin::PaymentMethodsController.class_eval do
  
  before_filter :load_calculators
  
  def load_calculators
    @calculators = PaymentMethod.calculators.sort_by(&:name)
    puts 'loading'
  end
  
end