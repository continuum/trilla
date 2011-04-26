class SessionsController < ApplicationController
  skip_before_filter :ensure_signed_in
  
  def new
    client = GData::Client::Contacts.new
    next_url = request.url.gsub("new", "store")
    secure = false
    sess = true
    domain = 'continuum.cl' 
    authsub_link = client.authsub_url(next_url, secure, sess, domain)
    redirect_to(authsub_link)
  end
  
  def store
    if params[:token].nil?
       destroy
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
  
  def destroy
    reset_session
    redirect_to("/")
  end
  
end
