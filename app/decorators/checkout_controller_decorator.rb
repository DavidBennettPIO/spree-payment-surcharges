CheckoutController.class_eval do
  
  before_filter :delete_orphened_adjustment
  
  private
  
    def delete_orphened_adjustment
      Payment.delete_orphened_adjustment
    end
  
end