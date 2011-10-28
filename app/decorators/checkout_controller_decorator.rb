CheckoutController.class_eval do
  
  before_filter :reload_payments
  after_filter :reload_payments
  
  def reload_payments
    real_payments = Payment.where(:order_id => @order.id).all
    
    Adjustment.where("order_id = '#{@order.id}' AND originator_type = 'PaymentMethod' AND source_id NOT IN (?)", real_payments).destroy_all
    Adjustment.where("order_id = '#{@order.id}' AND originator_type = 'PaymentMethod' AND amount = 0").destroy_all
    
    @order.payments.reload
    @order.update!
  end
  
end