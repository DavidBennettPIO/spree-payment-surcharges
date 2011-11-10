require 'spec_helper'

describe Gateway::Eway do

  context "options" do
    
    let (:gateway) { Gateway::Eway.new }
    
    it "should include :test => true in  when :test_mode is true" do
      gateway.prefers_test_mode = true
      gateway.options[:test].should == true
    end

    it "should not include :test when test_mode is false" do
      gateway.prefers_test_mode = false
      gateway.options[:test].should be_nil
    end
  end
  
  context "order_tests" do
    
    before(:each) do

      @gateway = Factory(:gateway_eway_payable)
      @gateway.save!
  
      @country = Factory(:country, :name => "Australia", :iso_name => "AUSTRALIA", :iso3 => "AUS", :iso => "AU", :numcode => 36)
      @state   = Factory(:state, :name => "South Australia", :abbr => "SA", :country => @country)
      @address = Factory(:address,
        :firstname => 'John',
        :lastname => 'Doe',
        :address1 => '1234 My Street',
        :address2 => 'Apt 1',
        :city =>  'Mount Barker',
        :zipcode => '5152',
        :phone => '(08) 5555 5555',
        :state => @state,
        :country => @country
      )
      
      @order = Factory(:order_with_totals, :bill_address => @address, :ship_address => @address)
      @order.state = "payment"
      @order.save
      @order.update!
      
      @gateway.save
      @gateway.calculator.save

    end

    context "purchase" do
      
      before {
        Spree::Config.set :auto_capture => true
        @gateway.save
      }
    
      it "should be able to send a test purchase to eWay for $10 inc surcharge" do
        
        @gateway.options[:test].should == true
        
        surcharge = 10.0/11.0
        item_price = 10-surcharge
        
        @order.line_items.first.price = item_price
        
        @order.update!
        @order.save

        @order.item_total.should == item_price
        @order.total.should == item_price
        @order.adjustment_total.should == 0

        @order.update_attributes(
          {
            :payments_attributes => [
              :payment_method_id => @gateway.id,
              :amount => 10,
              :source_attributes => {
                :number => '4444333322221111',
                :verification_value => '123',
                :month => '9',
                :year => Time.now.year + 1,
                :first_name => 'John',
                :last_name => 'Doe'
              }
            ]
          }
        )
        
        @order.update!

        @order.adjustment_total.round(2).should == surcharge.round(2)
        
        @order.next!
        @order.state.should == 'complete'
      end
    end
  end
end
