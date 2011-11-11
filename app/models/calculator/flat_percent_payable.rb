class Calculator::FlatPercentPayable < Calculator
  preference :flat_percent_payable, :decimal, :default => 0

  def self.description
    I18n.t("flat_percent_payable")
  end

  def self.register
    super
  end

  def compute(order)
    return 0 unless order.present?
    
    unless order.is_a? Order
      return 0 unless order.order.is_a? Order
      order = order.order
    end

    return 0 unless order.item_total.present?

    adjustment_total = order.adjustments.without_payment_surcharge.map(&:amount).sum
    
    payable_total = order.item_total + adjustment_total - order.payment_total

    payable_total * (self.preferred_flat_percent_payable / 100.0)
  end
end
