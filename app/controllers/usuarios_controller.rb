class UsuariosController < ApplicationController
  def index
    @usuarios = Usuario.all
  end

  def show
    @usuario = Usuario.find(params[:id])
    @usuario_sesion = session[:usuario]
    @isPerfil = params[:p]
    if (!@isPerfil.nil?)
      if (@usuario.id != @usuario_sesion.id)
        @usuario = @usuario_sesion
      end
    end
  end

  def new
    @usuario = Usuario.new
  end

  def edit
    @usuario = Usuario.find(params[:id])
    @usuario_sesion = session[:usuario]
    @isPerfil = params[:p]
    if (!@isPerfil.nil?)
      if (@usuario.id != @usuario_sesion.id)
        @usuario = @usuario_sesion
      end
    end
  end

  def create
    @usuario = Usuario.new(params[:usuario])
    if @usuario.save
      flash[:notice] = 'Usuario was successfully created.'
      redirect_to(@usuario)
    else
      render :action => "new"
    end
  end

  def update
    @usuario = Usuario.find(params[:id])
    if @usuario.update_attributes(params[:usuario])
      flash[:notice] = 'Usuario was successfully updated.'
      redirect_to(@usuario)
    else
      render :action => "edit"
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    redirect_to(usuarios_url)
  end
end
