class UsuariosController < ApplicationController
  before_filter :authorizate_admin, :except => [:show, :edit, :update]
  
  def index
    @usuarios = Usuario.all
  end

  def show
    @isPerfil = params[:perfil]
    if @isPerfil
      @usuario = Usuario.find(session[:usuario_id])
    elsif session[:usuario].admin?
        @usuario = Usuario.find(params[:id])
      else
        authorizate_admin
    end
  end

  def new
    @usuario = Usuario.new
  end

  def edit
    show
  end

  def create
    @usuario = Usuario.new(params[:usuario])
    if @usuario.save
      flash[:notice] = 'Usuario was successfully created.'
      redirect_to(usuarios_url)
    else
      render :action => "new"
    end
  end

  def update
    show
    usuarios_url = '/perfil' if @isPerfil
    unless session[:usuario].admin?
      params[:usuario][:perfil] = "USUARIO"
      flash[:warning] = 'No tienen acceso para cambiar perfil. Cambiando a por defecto: USUARIO'
    end
     

    if @usuario.update_attributes(params[:usuario])
      session[:usuario] = @usuario if session[:usuario].id == @usuario.id
      flash[:notice] = 'Usuario fue actualizado.'
      redirect_to(usuarios_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    if @usuario.destroy
      redirect_to(usuarios_url)
    else
      @usuario.errors.full_messages.map { |msg| flash[:error] = msg }
      redirect_to(usuarios_url)
    end
    
  end
end
