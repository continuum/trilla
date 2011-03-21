Capybara.javascript_driver = :selenium

Spec::Runner.configure do |config|
  config.before(:all) { Capybara.default_driver = Capybara.javascript_driver }

  config.before(:each) do
    Capybara.current_driver = Capybara.javascript_driver if options[:js]
  end

  config.after(:each) do
    Capybara.use_default_driver if options[:js]
  end
end