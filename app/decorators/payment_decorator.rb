Payment.class_eval do
  
  has_one :adjustment, :as => :source, :dependent => :destroy
  
  after_save :ensure_correct_adjustment, :update_order
  after_create :ensure_correct_adjustment # Create it ASACP
  
  before_save :delete_orphened_adjustment
  
  # The adjustment amount associated with this payment (if any.)  Returns only the first adjustment to match
  # the payment but there should never really be more than one.
  def cost
    adjustment ? adjustment.amount : 0
  end
  
  def will_cost
    payment_method.calculator.compute(order)
  end
  
  def line_items
    order.line_items
  end
  
  def ensure_correct_adjustment
    delete_orphened_adjustment
    if adjustment
      if will_cost > 0
        adjustment.originator = payment_method
        adjustment.save
      else
        adjustment.destroy
      end
    else
      payment_method.create_adjustment(I18n.t(:payment_surcharge), order, self, true) unless will_cost == 0
      order.update!
    end
  end
  
  def delete_orphened_adjustment
    real_payments = order.payments.where("state != ?", 'failed').all
    to_kill = order.adjustments.payment.where("source_id NOT IN (?) OR amount = ?", real_payments, 0.0)
    if to_kill.size > 0
      to_kill.destroy_all
      order.update!
    end
  end
end