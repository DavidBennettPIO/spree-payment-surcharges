Admin::PaymentMethodsController.class_eval do
  
  before_filter :load_calculators
  
  def load_calculators
    @calculators = Rails.application.config.spree.calculators.payment_surcharges_create_adjustments
  end
  
end