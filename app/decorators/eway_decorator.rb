Gateway::Eway.class_eval do
  
  def options
    # add :test key in the options hash, as that is what the ActiveMerchant::Billing::EwayGateway expects
    if self.prefers? :test_mode
      self.class.default_preferences[:test] = true
    else
      self.class.default_preferences.delete(:test)
    end

    super
  end
  
  def payment_profiles_supported?
    false
  end
  
end