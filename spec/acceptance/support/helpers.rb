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
    click_link "Sign out" if page.has_link? "Sign out" # logs out of google, english
    click_link "Salir" if page.has_link? "Salir" # logs out of google, spanish
  end

  def usuario
    Usuario.find_by_email(USERNAME) || Fabricate(:usuario, :email => USERNAME)
  end

  def click_stop_clock_button
    find(:css, "a.stop").click
  end

  def within_timer_row(temporizador)
    within(:css, "#tr_timesheet-#{temporizador.id}") do
      yield
    end
  end

  def within_proyecto_row(proyecto)
    within(:xpath, "//tr[@id='trProyecto-#{proyecto.id}']") do
      yield
    end
  end
end

module Capybara::Node::Matchers
  def has_clock_running?
    has_css?(".clock.running")
  end

  def has_no_clock_running?
    has_no_css?(".clock.running")
  end

  def has_clock?
    has_css?(".clock")
  end

  def has_selected_tab?(name)
    has_css?(".tab-select a", :text => name)
  end

  def has_unselected_tab?(name)
    has_css?(".tab-unselect a", :text => name)
  end

  def has_proyecto?(proyecto)
    has_xpath?("//tr[@id='trProyecto-#{proyecto.id}']")
  end
end

Spec::Runner.configuration.include(HelperMethods)
