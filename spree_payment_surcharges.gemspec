Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payment_surcharges'
  s.version     = '0.70.0'
  s.summary     = 'Allows you to add a surcharge to your payments to help recoup costs.'
  s.description = 'Are you using spree? Are your margins too low? Install spree_payment_surcharges to add an extra invoice adjustment so you never get burnt again :)'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'David Bennett'
  s.email             = 'davidbennett@bravevision.com'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core', '>= 0.70.0')
  s.add_development_dependency 'rspec-rails'
end

