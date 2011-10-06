module SpreePaymentSurcharge
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
    
    initializer "spree.payment_surcharges.register.promotion.calculators" do |app|
      app.config.spree.calculators.add_class('payment_surcharges_create_adjustments')
      app.config.spree.calculators.payment_surcharges_create_adjustments = [
        Calculator::FlatPercentItemTotal,
        Calculator::FlatRate,
        Calculator::FlatPercentPayable
      ]
    end
    
  end
end
