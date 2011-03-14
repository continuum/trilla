module HelperMethods
  def login
    visit "/"
    # By default google stores the session in our browser, so this might not
    # be needed
    if page.has_xpath? "//input[@id='signIn']"
      fill_in 'Email', :with => USERNAME
      fill_in 'Passwd', :with => PASSWORD
      click_button "signIn"
      click_button "allow"
    end
  end

  def logout
    visit "/"
    click_link "Salir" if page.has_link? "Salir" # logs out of trilla
    click_link "Logout" if page.has_link? "Logout" # logs out of google, english
    click_link "Salir" if page.has_link? "Salir" # logs out of google, spanish
  end
end

Spec::Runner.configuration.include(HelperMethods)
