module AuthenticationHelper
  
  def signed_in?
    !session[:usuario_id].nil? || login_from_api_key
  end
  
  def current_user
    @current_user ||= (Usuario.find(session[:usuario_id]) || login_from_api_key)
  end
  
  def login_from_api_key
    if !params[:api_key].nil?
      @current_user = Usuario.find_by_api_key(params[:api_key]) unless params[:api_key].empty?
      session[:usuario] = @current_user
      session[:usuario_id] = @current_user.id
    end
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

  def authorizate_admin
    unless session[:usuario].admin?
      flash[:error] = "No posee perfil de administrador para acceder a esta opción"
      redirect_to "/"
      false
    end
  end
  
end