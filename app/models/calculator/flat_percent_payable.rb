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
    
    # Get the order and payment objects
    if object.is_a? Order
      order = object
      payment = order.payment if order.payment.present?
    elsif object.is_a? Payment
      payment = object
      return 0 unless payment.order.present?
      order = payment.order
    else
      return 0
    end
    
    if payment.present? && payment.amount > 0 # has the payable amount
      surcharge = payment.find_adjustment.present? ? payment.find_adjustment.amount : 0
      return surcharge if ['complete', 'void', 'failed'].include?(payment.state) # Dont change the surcharge once its paid.
      payable_total = payment.amount - surcharge
    else
      return 0 unless order.item_total.present?
      adjustment_total = order.adjustments.eligible.map(&:amount).sum - order.payment_surcharge_total
      payable_total = order.item_total + adjustment_total - order.payment_total
    end

    payable_total * (self.preferred_flat_percent_payable / 100.0)
  end
end
