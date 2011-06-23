require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Consultar Reportes" do
  let!(:pepito) {usuario}
  
  background do
    login(pepito)
    click_link 'Reportes'
    click_link 'Consultar reportes'
  end

  scenario "Funcionalidad del botón Ayuda." do
    page.should have_link 'Ayuda'
    find('#div-ayuda-sql').should_not be_visible
    click_link 'Ayuda'
    find('#div-ayuda-sql').should be_visible
    click_link 'Ayuda'
    find('#div-ayuda-sql').should_not be_visible
  end

  scenario "Ejecución de consulta para generar el reporte." do
    fill_in 'querys-sql', :with => 'SELECT * FROM temporizadors'
    click_button 'Ejecutar'
    within(:id, 'resultados-sql') do
      page.should have_selector 'table'
      page.should have_content 'SQL'
    end
  end

  scenario "Funcionalidad de filas máximas por reporte." do
    usuario1 = Fabricate(:usuario, :nombres => 'Carlos Casselli', :email => 'carloscasselli@goleador.cl')
    usuario2 = Fabricate(:usuario, :nombres => 'Rey Arturo', :email => 'reyarturo@mesaredonda.cl')
    check 'isMaxrows'
    fill_in 'maxrows', :with => '1'
    fill_in 'querys-sql', :with => 'SELECT * FROM usuarios'
    click_button 'Ejecutar'
    within(:id, 'resultados-sql') do
      page.should have_selector('tbody tr', :count => 2)
    end
  end

end


feature "Nuevo Reporte" do
  let!(:pepito) {usuario}

  background do
    login(pepito)
  end

  scenario "Se visualiza la lista de reportes creados" do
    reporte1 = Fabricate(:reporte, :nombre => "Reporte 2011")
    reporte2 = Fabricate(:reporte, :nombre => "Reporte 2012")
    click_link "Reportes"
    page.should have_selector('.tr_reporte', :count => 2)
  end

  scenario "Se visualiza el formulario de creación del reporte." do
    pending
    page.should have_field 'Nombre'
    page.should have_field 'Descripción'
    page.should have_field 'Query'
    page.should have_field 'Tipo'
    page.should have_button 'Crear'
    page.should have_link 'Cancelar'
  end
  
  scenario "Se crea el reporte exitosamente" do
    pending
    reporte1 = Fabricate(:reporte, :nombre => "Reporte 2011", :tipo => 'Registro Horas')
    fill_in 'Nombre', :with => 'Nuevo Reporte 2013'
    fill_in 'Descripción', :with => 'Descripción del nuevo reporte'
    fill_in 'Query', :with => 'SELECT * FROM temporizadors'
    select 'Registro Horas', :from => 'Tipo'
    click_button 'Crear'
    page.should have_content 'Nuevo Reporte 2013'
  end

end
