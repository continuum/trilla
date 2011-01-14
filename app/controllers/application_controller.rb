# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticationHelper
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
end