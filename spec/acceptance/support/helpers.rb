module HelperMethods
  def login
    visit "/"
    # By default google stores the session in our browser, so this might not
    # be needed
    if page.has_xpath? "//form[@action='https://www.google.com/a/continuum.cl/LoginAction2?service=apps']"
      fill_in 'Email', :with => USERNAME
      fill_in 'Passwd', :with => PASSWORD
      click_button "signIn"
      click_button "allow"
    end
  end
end

Spec::Runner.configuration.include(HelperMethods)
