require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Login" do
  background do
    visit "/"
  end

  scenario "System shows a google account login", :js => true do
    page.should have_xpath("//form[@action='https://www.google.com/a/continuum.cl/LoginAction2?service=apps']")
  end

  scenario "Logs in with the right credentials", :js => true do
    fill_in 'Email', :with => USERNAME
    fill_in 'Passwd', :with => PASSWORD
    click_button "signIn"
    page.should have_xpath("//input[@id='allow']")
    page.should have_xpath("//input[@id='deny']")
    click_button "allow"
    page.should have_content("Trilla Time Tracking")
  end
end
