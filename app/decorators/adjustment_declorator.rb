Adjustment.class_eval do
  
  scope :payment_surcharge, lambda { where("originator_type = 'PaymentMethod'") }
  
end