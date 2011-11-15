Order.class_eval do
  
  def payment_surcharge_total
    adjustments.payment.map(&:amount).sum
  end
  
end