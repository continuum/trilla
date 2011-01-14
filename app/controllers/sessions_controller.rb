class SessionsController < ApplicationController
  
  def new
     # response.headers['WWW-Authenticate'] = Rack::OpenID.build_header(
     #     :identifier => "https://www.google.com/accounts/o8/.well-known/host-meta?hd=continuum.cl",
     #     :required => ["http://axschema.org/contact/email",
     #                  "http://axschema.org/namePerson/first",
     #                  "http://axschema.org/namePerson/last"],
     #     :return_to => sessions_url,
     #    :method => 'POST')
     #  head 401
     
    client = GData::Client::Contacts.new
    next_url = 'http://localhost:3000/sessions'
    secure = false
    sess = true
    domain = 'continuum.cl' 
    authsub_link = client.authsub_url(next_url, secure, sess, domain)
    redirect_to(authsub_link)
     
  end
  
  def show
    if params[:token].nil?
      redirect_to(session[:redirect_to])
      return
    end
    
    client = GData::Client::Contacts.new
    client.authsub_token = params[:token] # extract the single-use token from the URL query params
    session[:token] = client.auth_handler.upgrade()
    client.authsub_token = session[:token] if session[:token]
    
    feed = client.get('http://www.google.com/m8/feeds/contacts/default/full?max-results=0').to_xml
    
    nombre_usuario = ''
    email_usuario = ''
    feed.elements.each('author') do |entry|
        nombre_usuario = entry.elements['name'].text
        email_usuario = entry.elements['email'].text
    end
    
    usuario = Usuario.find_by_email(email_usuario)
    if usuario.nil?
      usuario = Usuario.new
      usuario.nombres = nombre_usuario
      usuario.email = email_usuario
      usuario.perfil = Usuario.all.length == 0 ? 'ADMIN' : 'USUARIO'
      usuario.save
    end
    session[:usuario_id] = usuario.id
    session[:login] = usuario.email
    session[:usuario] = usuario
    session[:usuario_perfil] = usuario.perfil
    redirect_to(session[:redirect_to])
  end
  
  def create
 
    # if openid = request.env[Rack::OpenID::RESPONSE]
    #   case openid.status
    #   when :success
     #    ax = OpenID::AX::FetchResponse.from_success_response(openid)
      #   user = Usuario.find_by_rut('15587917')
      #   session[:user_id] = user.id
      #   session[:login] = user.rut
      #   session[:usuario_id] = user.id
      #   session[:usuario] = user
      #   session[:usuario_perfil] = user.perfil
      #   redirect_to(session[:redirect_to] || root_path)
     #  when :failure
     #    render :action => 'problem'
     #  end
    # else
     #  redirect_to new_sessions_path
    # end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
end