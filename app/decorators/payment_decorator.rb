Payment.class_eval do
  
  has_one :adjustment, :as => :source, :dependent => :destroy
  
  before_create :delete_orphened_adjustments
  
  after_create :ensure_correct_adjustment # Create it ASACP

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
  
  def process!
    ensure_correct_adjustment # do this before the payment
    if !processing? and source and source.respond_to?(:process!)
      started_processing!
      source.process!(self)
    end
    reload # Get rid of the number etc
  end
  
  def ensure_correct_adjustment

    return if ['complete', 'void', 'failed'].include?(state) # Dont change the surcharge once its paid.
    
    save

    delete_bad_adjustments
    
    update_order

    a = find_adjustment

    if !a.nil?
      if will_cost > 0
        a.originator = payment_method
        a.source_id = id if !id.nil? && id > 0 && a.source_id != id # created before it's saved
        a.save
      else
        a.destroy
      end
    elsif will_cost > 0
      adjustment = payment_method.create_adjustment(I18n.t(:payment_surcharge), order, self, true)
      adjustment.save unless adjustment.nil?
      save # to make sure have have the adjustment attached from our calculator
    end

    update_order # adjustment create/destroy *should* have does this already...
    
  end
  
  # Something creates a heap of bad adjustments... sometimes
  def delete_bad_adjustments
    
    order.adjustments.payment.where("amount < ?", 0.01).destroy_all

    a = find_adjustment
    aid = a.nil? ? 0 : a.id
    if !id.nil? && id > 0 && aid > 0 # saved so remove any bad adjustments 
      order.adjustments.payment.where("source_id = ? AND id != ?", id, aid).destroy_all
    end

  end
  
  # If the user changes there payment method or theres a failed payment...
  # we should remove the adjustments (:as => :source, :dependent => :destroy dont work sometimes...)
  def delete_orphened_adjustments
    order.adjustments.payment.where("source_id NOT IN (?)", order.payments.completed).destroy_all
  end
  
  
  # adjustment dosnt attach its self until it's saved... sometimes
  def find_adjustment
    return adjustment if !adjustment.nil?
    a = order.adjustments.payment.where("source_id = ?", id).first
    adjustment = a unless a.nil?
    return adjustment
  end
  
  private
    # I need to save so I can create the adjustment... but reload kills the number etc
    def update_order
      order.update!
    end
  
end