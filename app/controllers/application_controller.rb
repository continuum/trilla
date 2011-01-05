# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  session :session_key => 'harv_id'
  
  before_filter :authorize, :except => [:login]

  protected
  def authorize
    
    Time.zone = "Santiago"
    #Time.zone = "GMT-04:00"
    
    unless Usuario.find_by_login(session[:login])
      @usu = Usuario.find_by_login(session[:login])
      redirect_to :controller => 'init', :action => 'login'
    end
  
  end

end