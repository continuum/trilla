module HelperMethods
  def login
    visit "/"
    fill_in 'Email', :with => USERNAME
    fill_in 'Passwd', :with => PASSWORD
    click_button "Sign in"
    click_button "Conceder acceso"
  end
end

Spec::Runner.configuration.include(HelperMethods)
