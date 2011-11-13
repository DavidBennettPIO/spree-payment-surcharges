FactoryGirl.define do
  factory :eway_payable_payment_method, :class => Gateway::Eway do
    
    name "Eway Gateway"
    environment "test"
    active true
    
    calculator { |g| Factory(:calculator_payable, :calculable_id => g.object_id, :calculable_type => 'PaymentMethod') }
    
    after_create do |g|
      g.set_preference(:login, "87654321" )
      g.set_preference(:test_mode, true )
      g.save
      g.calculator.save
    end
  end
  
  factory :payable_payment_method, :class => Gateway::Bogus do
    
    name "Some Gateway"
    environment "test"
    active true
    
    calculator { |g| Factory(:calculator_payable, :calculable_id => g.object_id, :calculable_type => 'PaymentMethod') }
    
    after_create do |g|
      g.save
      g.calculator.save
    end

  end
  
end