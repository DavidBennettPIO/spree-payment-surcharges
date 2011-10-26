Payment.class_eval do
  
  has_one :adjustment, :as => :source
  
  after_save :ensure_correct_adjustment, :update_order
  
  before_save :delete_orphened_adjustment
  
 
  #validates :calculator, :presence => true
  
  # The adjustment amount associated with this shipment (if any.)  Returns only the first adjustment to match
  # the shipment but there should never really be more than one.
  def cost
    adjustment ? adjustment.amount : 0
  end
  
  def line_items
    order.line_items
  end
  
  def ensure_correct_adjustment
    delete_orphened_adjustment
    if adjustment
      adjustment.originator = payment_method
      adjustment.save
    else
      puts payment_method
      payment_method.create_adjustment(I18n.t(:payment_surcharge), order, self, true)
      reload #ensure adjustment is present on later saves
    end
  end
  
  def delete_orphened_adjustment
    
    real_payments = Payment.where(:order_id => order.id).all
    
    Adjustment.where("order_id = '#{order.id}' AND originator_type = 'PaymentMethod' AND source_id NOT IN (?)", real_payments).all.each do |a|
      puts a
    end
    
    
  end
  
end