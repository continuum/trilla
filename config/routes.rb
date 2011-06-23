ActionController::Routing::Routes.draw do |map|
  map.resources :usuarios
  map.resources :tareas
  map.resources :proyecto_tareas
  map.resources :proyecto_usuarios
  map.resources :usuarios
  map.resources :proyectos, :member => { :archive => :get, :restore => :get }
  map.resources :reportes, :collection => { :sql => :get, :execute => :get, :export_csv => :post}

  map.resources :clientes
  map.resource :sessions
    
  map.root :controller => 'timesheet'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/perfil/:action/:id', :controller => "usuarios", :action => "show", :perfil => true
  map.connect '/timesheet/day/:day_of_the_year/:year', :controller => "timesheet", :action => "day"

end