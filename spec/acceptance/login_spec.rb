require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Login" do
  background do
    visit "/"
  end

  scenario "System shows a google account login", :js => true do
    page.should have_content("A third party service is requesting permission to access")
    page.should have_content("Continuum Ltda account")
  end

  scenario "Logs in with the right credentials", :js => true do
    fill_in 'Email', :with => USERNAME
    fill_in 'Passwd', :with => PASSWORD
    click_button "Sign in"
    page.should have_content("ha solicitado acceso a tu Cuenta de Continuum")
    click_button "Conceder acceso"
    page.should have_content("Trilla Time Tracking")
  end
end
