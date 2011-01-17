class TareasController < AdminController
  def index
    @tareas = Tarea.all
  end

  def show
    @tarea = Tarea.find(params[:id])
  end

  def new
    @tarea = Tarea.new
  end

  def edit
    @tarea = Tarea.find(params[:id])
  end

  def create
    @tarea = Tarea.new(params[:tarea])
    if @tarea.save
      flash[:notice] = 'Tarea was successfully created.'
      redirect_to(@tarea)
    else
      render :action => "new"
    end
  end

  def update
    @tarea = Tarea.find(params[:id])
    if @tarea.update_attributes(params[:tarea])
      flash[:notice] = 'Tarea was successfully updated.'
      redirect_to(@tarea)
    else
      render :action => "edit"
    end
  end

  def destroy
    @tarea = Tarea.find(params[:id])
    @tarea.destroy
    redirect_to(tareas_url)
  end
end
