Adjustment.class_eval do
  
  scope :payment_surcharge, lambda { where("originator_type = 'PaymentMethod'") }
  scope :without_payment_surcharge, lambda { where("originator_type != 'PaymentMethod'") }
  
end