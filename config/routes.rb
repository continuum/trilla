ActionController::Routing::Routes.draw do |map|
  map.resources :usuarios
  map.resources :tareas
  map.resources :temporizadors
  map.resources :proyecto_tareas
  map.resources :proyecto_usuarios
  map.resources :usuarios
  map.resources :proyectos
  map.archive_proyecto 'proyectos/:id/archive', :controller => 'proyectos', :action => 'archive'
  map.resources :clientes
  map.resource :sessions
    
  map.root :controller => 'timesheet'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
