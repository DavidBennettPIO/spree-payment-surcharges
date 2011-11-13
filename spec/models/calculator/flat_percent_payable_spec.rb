require 'spec_helper'

describe Calculator::FlatPercentPayable do
  
  let(:order) { Factory(:order_with_totals) }
  let(:payment_method) { Factory(:payable_payment_method) }
  let(:calculator) { payment_method.calculator } # Needs to attach for the prefs
  let(:payment) { Payment.new :order => order, :state => 'pending', :payment_method => payment_method }
  
  before do
    order.save
    order.update!
  end
  
  context "#compute" do
    
    context "without adjustments" do

      it "should cost 10% of the order item total" do
        calculator.compute(order).should == (order.item_total)*0.1
      end
      it "should cost 10% of the order item total excluding payment surcharges" do
        Factory(:adjustment, :order => order, :amount => 5, :originator => payment_method, :source => payment)
        order.adjustments.reload
        order.update!
        calculator.compute(order).should == (order.item_total)*0.1
      end
    end

    context "with adjustments" do
      before do
        Factory(:adjustment, :order => order, :amount => 10)
        Factory(:adjustment, :order => order, :amount => 5)
        @a = Factory(:adjustment, :order => order, :amount => -2, :eligible => false)
        @a.update_attribute_without_callbacks(:eligible, false)
        order.stub(:update_adjustments, nil)
        order.adjustments.reload
        order.update!
      end
      it "should cost 10% of the order item total + adjustments" do
        calculator.compute(order).should == (order.item_total+15)*0.1
      end
      it "should cost 10% of the order item total + adjustments excluding payment surcharges" do
        Factory(:adjustment, :order => order, :amount => 5, :originator => payment_method, :source => payment)
        @a.update_attribute_without_callbacks(:eligible, false) # It forgets..
        order.adjustments.reload
        order.update!
        calculator.compute(order).should == (order.item_total+15)*0.1
      end
    end
  end
end