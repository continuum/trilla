require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Login" do
  background do
    logout
    visit "/"
  end

  scenario "sistema muestra un login de Google" do
    page.should have_xpath("//form[contains(@action, 'https://www.google.com/a/')]")
  end

  scenario "usuario ingresa las credenciales correctas" do
    fill_in 'Email', :with => USERNAME
    fill_in 'Passwd', :with => PASSWORD
    click_button "signIn"
    page.should have_xpath("//input[@id='allow']")
    page.should have_xpath("//input[@id='deny']")
    click_button "allow"
    page.should have_content("Trilla Time Tracking")
  end
end

feature "Login con API Key" do
  let!(:pepito) {usuario}
  
  background do
     logout
   end
   
  scenario "usuario ingresa con token" do
    pepito.enable_api!
    visit "/?api_key=" + pepito.api_key
    page.should have_content("Trilla Time Tracking")
  end
end
