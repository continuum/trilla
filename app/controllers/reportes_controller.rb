require 'fastercsv'

class ReportesController < ApplicationController
    
  def index
    @tipos = ActiveRecord::Base.connection.execute('SELECT distinct(r.tipo) FROM reportes r where r.tipo is not null')#.map { |cli| [cli.tipo, cli.nombre] }
    @reportes = Reporte.all
  end

  def show
    @reporte = Reporte.find(params[:id])
  end

  def new
    @reporte = Reporte.new
  end

  def edit
    @reporte = Reporte.find(params[:id])
  end  
  
  def destroy
    @reporte = Reporte.find(params[:id])
    @reporte.destroy
    redirect_to(reportes_url)
  end
  
  def create
    @reporte = Reporte.new(params[:reporte])
    if @reporte.save
      flash[:notice] = 'Reporte was successfully created.'
      redirect_to(reportes_url)
    else
      render :action => "new"
    end
  end  
    
  def execute
    
    querys = params[:querys]
    maxrows = params[:maxrows] || -1
    maxrows= maxrows.to_i
    
    s = querys.split("}SQL")

    count = 0
   
    result = {:msg => 'ok', :success => true}
   
    s.each do |d|
      
      query = d.sub('SQL{','')
      
      #if query.upcase.start_with?("SELECT ")
        
        if maxrows > 0
          res = ActiveRecord::Base.connection.execute("#{query} limit #{maxrows}")
        else
          res = ActiveRecord::Base.connection.execute(query)
        end
        
        result.merge!({"result#{count}" => {:data => res, :sql => query, :maxrows => maxrows }})
        count+= 1
      #end
      
    end
   
    result.merge!({:countResults => count})
   
    render :json => result
  end
  
  
  def export_csv
    
    query = params[:query]
    maxrows = params[:maxrows].to_i
    
    if maxrows > 0
      res = ActiveRecord::Base.connection.execute("#{query} limit #{maxrows}")
    else
      res = ActiveRecord::Base.connection.execute(query)
    end
  
    csv_string = FasterCSV.generate(:col_sep => ";", :row_sep => "\r\n") { |csv|
      csv << res[0].keys
      res.each do |obj|
        csv << obj.values
      end
    }

    outfile = "export_" + Time.now.strftime("%m-%d-%Y") + ".xls"

    send_data csv_string, :type => 'application/vnd.ms-excel; charset=UTF-8; header=present', :disposition => "attachment; filename=#{outfile}"
    
  end
  
  def save_query_report
    
    reporte = Reporte.new(params[:reporte])
    reporte.save
    
    render :json => {:msg => 'ok', :success => true}
  end
  
  def tipos_reportes
    tipos = ActiveRecord::Base.connection.execute('SELECT distinct(r.tipo) FROM reportes r where r.tipo is not null')
    result = {:msg => 'ok', :success => true, :tipos => tipos}
    render :json => result
  end
  
  def sql
    
  end
  
end
