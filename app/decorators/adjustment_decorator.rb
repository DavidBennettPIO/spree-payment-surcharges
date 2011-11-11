Adjustment.class_eval do
  
  scope :payment_surcharge, where(:originator_type => 'PaymentMethod')
  scope :without_payment_surcharge, where("originator_type != 'PaymentMethod'")
  
end