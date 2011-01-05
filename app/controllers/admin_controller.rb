class AdminController < ApplicationController

  before_filter :authorize

  protected
  def authorize
    
    @usuario = session[:usuario]
    
    if (session[:usuario_perfil] != 'ADMIN')
      redirect_to(:controller=>'timesheet',:action => "index" )
    end
    
  end
  
end
