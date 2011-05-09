# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :errors
  include AuthenticationHelper
  before_filter :ensure_signed_in
  before_filter :set_default_time_zone
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  def set_default_time_zone
    return if self.controller_name == 'sessions'
    Time.zone = session[:usuario].time_zone
  end

end