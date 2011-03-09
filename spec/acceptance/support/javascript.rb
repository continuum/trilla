Spec::Runner.configure do |config|
  config.before(:each) do
    Capybara.current_driver = :selenium if options[:js]
  end

  config.after(:each) do
    Capybara.use_default_driver if options[:js]
  end
end