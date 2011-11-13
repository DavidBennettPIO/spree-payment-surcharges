Adjustment.class_eval do
  
  scope :payment, lambda { where(:originator_type => "PaymentMethod") }
  scope :without_payment, lambda { where("originator_type != 'PaymentMethod'") }
  
end