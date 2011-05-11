class ClientesController < ApplicationController
  before_filter :authorizate_admin
  
  def index
    @clientes = Cliente.all
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    @cliente = Cliente.find(params[:id])
  end

  def create
    @cliente = Cliente.new(params[:cliente])
    if @cliente.save
      flash[:notice] = 'Cliente was successfully created.'
      redirect_to(clientes_url)
    else
      render :action => "new"
    end
  end

  def update
    @cliente = Cliente.find(params[:id])
    if @cliente.update_attributes(params[:cliente])
      flash[:notice] = 'Cliente was successfully updated.'
      redirect_to(clientes_url)
    else
      render :action => "edit"
    end
  end

  def destroy
    @cliente = Cliente.find(params[:id])
    if @cliente.destroy
      redirect_to(clientes_url)
    else
      index
      render :action => "index"
    end
    
  end
end
