class Calculator::FlatPercentPayable < Calculator
  preference :flat_percent_payable, :decimal, :default => 0

  def self.description
    I18n.t("flat_percent_payable")
  end

  def self.register
    super
  end

  def compute(object)
    return 0 unless object.present?
    if object.class.name.split('::').last.downcase == 'order'
      order = object
    elsif object.order.present?
      order = object.order
    else
      return 0
    end
    return 0 unless order.item_total.present?

    item_total = order.item_total
    adjustment_total = order.adjustments.without_payment_surcharge.map(&:amount).sum
    
    payable_total = item_total + adjustment_total

    payable_total * (self.preferred_flat_percent_payable / 100.0)
  end
end
