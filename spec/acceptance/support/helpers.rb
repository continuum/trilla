module HelperMethods
  def login(probador=nil)
    if probador.nil?
      probador = Fabricate(:usuario,
        :nombres => "El probador de aplicaciones",
        :email => "probador@continuum.cl",
        :perfil => "ADMIN"
      )
    end
    visit "/?id_mula=#{probador.id}"
  end

  def logout
    visit "/"
    click_link "Salir" if page.has_link? "Salir" # logs out of trilla
    click_link "Logout" if page.has_link? "Logout" # logs out of google, english
    click_link "Salir" if page.has_link? "Salir" # logs out of google, spanish
  end

  def usuario
    email = "#{USERNAME}@#{DOMAIN}"
    Usuario.find_by_email(email) || Fabricate(:usuario, :email => email)
  end

  def click_stop_clock_button
    find(:css, "a.stop").click
  end
  
  def within_total_hours_of_day
    within(:css, "#total_hours_of_day #hours_of_day") do
      yield
    end
  end
  
  def within_timer_row(temporizador)
    within(:css, "#tr_temporizador_#{temporizador.id}") do
      yield
    end
  end

  def within_proyecto_row(proyecto)
    within(:id, "tr_proyecto_#{proyecto.id}") do
      yield
    end
  end

  def within_contacto_row(contacto)
    within(:id, "tr_contacto_#{contacto.id}") do
      yield
    end
  end

  def within_tarea_row(tarea)
    within(:id, "tr_tarea_#{tarea.id}") do
      yield
    end
  end

  def within_usuario_row(usuario)
    within(:id, "tr_usuario_#{usuario.id}") do
      yield
    end
  end

  def within_cliente_row(cliente)
    within(:id, "tr_cliente_#{cliente.id}") do
      yield
    end
  end

  def click_start_clock_button
    find(:css, "a.start").click
  end

  def click_start_timer(temporizador)
    find(:css, "#tr_temporizador_#{temporizador.id} a.start").click
  end

end

module Capybara::Node::Matchers
  def has_timer_running?(temporizador)
    has_css?("#tr_temporizador_#{temporizador.id} .clock.running")
  end

  def has_clock_running?
    has_css?(".clock.running")
  end

  #Se deja versión negada, ya que no funciona bien "should_not" con peticiones ajax
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
    has_xpath?("//tr[@id='tr_proyecto_#{proyecto.id}']")
  end

  def has_tarea?(tarea)
    has_xpath?("//tr[@id='tr_tarea_#{tarea.id}']")
  end

  def has_usuario?(usuario)
    has_xpath?("//tr[@id='tr_usuario_#{usuario.id}']")
  end

  def has_cliente?(cliente)
    has_xpath?("//tr[@id='tr_cliente_#{cliente.id}']")
  end

  def has_contacto?(contacto)
    has_xpath?("//tr[@id='tr_contacto_#{contacto.id}']")
  end
end

Spec::Runner.configuration.include(HelperMethods)
