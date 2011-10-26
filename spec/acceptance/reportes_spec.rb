require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Consultar Reportes" do
  require 'net/http'
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

  scenario "Descargar archivo CSV de los resultados obtenidos en la consulta" do
    usuario1 = Fabricate(:usuario, :nombres => 'Carlos Casselli', :email => 'carloscasselli@goleador.cl')
    usuario2 = Fabricate(:usuario, :nombres => 'Rey Arturo', :email => 'reyarturo@mesaredonda.cl')
    fill_in 'querys-sql', :with => 'SELECT * FROM usuarios'
    click_button 'Ejecutar'
    page.should have_link 'Descargar CSV'
    result = Net::HTTP.post_form(URI.parse('http://localhost:3000/reportes/export_csv'),
                                          { 'query' => 'SELECT * FROM usuarios',
                                            'maxrows' => '-1'})
    result == Net::HTTPFound
  end
end

feature "Crear Reportes" do
  let!(:pepito) {usuario}

  background do
    login(pepito)
  end
  
  scenario "Se guarda el reporte desde consulta" do
    click_link "Reportes"
    click_link "Consultar reportes"
    fill_in "querys-sql", :with => "{SELECT * FROM temporizadors}"
    click_button 'Ejecutar'
    within(:id, 'resultados-sql') do
      click_link 'Guardar Reporte'
    end
    
  end
  
  scenario "Se visualiza la lista de reportes creados" do
    reporte1 = Fabricate(:reporte, :nombre => "Reporte 2011")
    reporte2 = Fabricate(:reporte, :nombre => "Reporte 2012")
    click_link "Reportes"
    page.should have_selector('.tr_reporte', :count => 2)
  end

  scenario "Se visualiza el formulario de creación del reporte." do
    click_link "Reportes"
    click_link "Crear reporte"
    page.should have_field 'Nombre'
    page.should have_field 'Descripción'
    page.should have_field 'Query'
    page.should have_field 'Tipo'
    page.should have_button 'Crear'
    page.should have_link 'Cancelar'
  end
  
  scenario "Se crea el reporte exitosamente" do
    reporte1 = Fabricate(:reporte, :nombre => "Reporte 2011", :tipo => 'Registro Horas')
    click_link "Reportes"
    click_link "Crear reporte"
    fill_in 'Nombre', :with => 'Nuevo Reporte 2013'
    fill_in 'Descripción', :with => 'Descripción del nuevo reporte'
    fill_in 'Query', :with => 'SELECT * FROM temporizadors'
    fill_in 'Tipo', :with => 'Tipo nuevo'
    click_button 'Crear'
    page.should have_content 'Nuevo Reporte 2013'
  end

end
