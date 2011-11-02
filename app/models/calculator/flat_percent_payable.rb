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
    
    sum = order.item_total
    if order.adjustments.present? && order.adjustments.size > 0
      order.adjustments.without_payment_surcharge.all.each do |adjustment|
        sum += adjustment.amount
      end
    end
    sum = sum * (self.preferred_flat_percent_payable / 100.0)
    sum
  end
end
