module HelperMethods
  def login
    visit "/"
    # By default google stores the session in our browser, so this might not
    # be needed
    if page.has_content? "requesting permission"
      fill_in 'Email', :with => USERNAME
      fill_in 'Passwd', :with => PASSWORD
      click_button "Sign in"
      click_button "Conceder acceso"
    end
  end
end

Spec::Runner.configuration.include(HelperMethods)
