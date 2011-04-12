module AuthenticationHelper
  
  def signed_in?
    !session[:usuario_id].nil?
  end
  
  def current_user
    @current_user ||= User.find(session[:usuario_id])
  end
  
  def ensure_signed_in
    if Rails.env.test? && !params[:id_mula].nil?
        session[:usuario]  = Usuario.find(params[:id_mula])
        session[:usuario_id] = params[:id_mula]
    else
      unless signed_in?
        session[:redirect_to] = request.request_uri
        redirect_to(new_sessions_path)
      end
    end
  end

  
end