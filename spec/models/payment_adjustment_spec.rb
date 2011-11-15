require 'spec_helper'

describe Payment do


  let(:calculator) { Calculator::FlatPercentPayable.new }
  let(:order) { Factory(:order_with_totals) }
  let(:payment_method) { Factory(:payment_method, :calculator => calculator) }
  let(:payment) { Payment.new :order => order, :state => 'pending', :payment_method => payment_method }
  let(:free_calculator) { Calculator::FlatPercentPayable.new }
  let(:free_order) { Factory(:order_with_totals) }
  let(:free_payment_method) { Factory(:payment_method, :calculator => free_calculator) }
  let(:free_payment) { Payment.new :order => free_order, :state => 'pending', :payment_method => free_payment_method }
  
  before {
    calculator.stub :preferred_flat_percent_payable => 10
    free_calculator.stub :preferred_flat_percent_payable => 0
  }

  context "#calculator" do
    it "should cost 10% of the order item total" do
      order.stub :total => 10
      payment.will_cost.should == 1.0
    end

    it "should return 0 of the order item total" do
      free_order.stub :total => 10
      free_payment.will_cost.should == 0.0
    end
  end
  
  context "#cost" do
    it "should return the amount of any payment charges that it originated" do
      payment.stub_chain :adjustment, :amount => 1.0
      payment.cost.should == 1.0
    end

    it "should return 0 if there are no relevant payment adjustments" do
      payment.cost.should == 0.0
    end
  end
  
  context "#ensure_correct_adjustment" do
    before {
      payment.stub(:reload)
      payment_method.save
      payment.save
      free_payment_method.save
      free_payment.save
    }

    it "should create adjustment when not present and has surcharge" do
      payment_method.should_receive(:create_adjustment).with(I18n.t(:payment_surcharge), order, payment, true)
      payment.send(:ensure_correct_adjustment)
    end
    
    it "should not create adjustment when not present and does not have surcharge" do
      free_payment_method.should_not_receive(:create_adjustment).with(I18n.t(:payment_surcharge), free_order, payment, true)
      free_payment.send(:ensure_correct_adjustment)
    end

    it "should update originator when adjustment is present" do
      payment.adjustment = Factory(:adjustment, :originator => payment_method, :amount => 10, :order => order)
      payment.adjustment.should_receive(:originator=).with(payment_method)
      payment.adjustment.should_receive(:save)
      payment.stub :will_cost => 2.49
      payment.send(:ensure_correct_adjustment)
    end
  end

  context "#update_order" do
    it "should update order" do
      order.should_receive(:update!)
      payment.send(:update_order)
    end
  end

  context "after_save" do
    it "should run correct callbacks" do
      payment.should_receive(:update_order)
      payment.run_callbacks(:save, :after)
    end
  end
  
end