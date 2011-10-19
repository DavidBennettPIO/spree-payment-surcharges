Adjustment.class_eval do
  
  scope :payment_surcharge, lambda { where(:label => I18n.t(:payment_surcharge)) }
  
end