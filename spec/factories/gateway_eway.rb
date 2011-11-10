FactoryGirl.define do
  factory :gateway_eway_payable, :class => Gateway::Eway do
    
    name "Eway Gateway"
    environment "test"
    active true
    
    calculator { |g| Factory(:calculator_payable, :calculable_id => g.object_id, :calculable_type => 'PaymentMethod') }
    
    after_create do |g|
      g.set_preference(:login, "87654321" )
      g.set_preference(:test_mode, true )
    end
  end
  
end