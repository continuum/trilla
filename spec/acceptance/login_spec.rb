require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Login" do
  before(:all) { Capybara.current_driver = :selenium }
  after(:all) { Capybara.use_default_driver }
  background do
    visit "/"
  end

  scenario "System shows a google account login" do
    page.should have_content("A third party service is requesting permission to access")
    page.should have_content("Continuum Ltda account")
  end
end
