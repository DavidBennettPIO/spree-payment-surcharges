class Calculator::FlatPercentPayable < Calculator
  preference :flat_percent_payable, :decimal, :default => 0

  def self.description
    I18n.t("flat_percent_payable")
  end

  def self.register
    super
    # The decorator has not added calculated_adjustments yet
    # PaymentMethod.register_calculator(self)
  end

  def compute(object)
    return unless object.present? and object.amount.present? 
    object.amount * (self.preferred_flat_percent_payable / 100.0)
  end
end
