FactoryGirl.define do
  factory :calculator_payable, :class => Calculator::FlatPercentPayable do
    after_create do |c|
      c.prefers_flat_percent_payable = 10
    end
  end
end