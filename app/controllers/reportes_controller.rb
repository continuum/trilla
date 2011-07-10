require 'fastercsv'

class ReportesController < ApplicationController
    
  def index
    @tipos = Reporte.tipos
    @reportes = Reporte.all
  end

  def show
    @reporte = Reporte.find(params[:id])
  end

  def new
    @reporte = Reporte.new
    @tipos = Reporte.tipos
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
      @tipos = Reporte.tipos
      flash[:notice] = 'Reporte was successfully created.'
      redirect_to(reportes_url)
    else
      @tipos = Reporte.tipos
      render :action => "new"
    end
  end  
    
  def execute
    querys = params[:querys]
    maxrows = params[:maxrows] || -1
    maxrows= maxrows.to_i
    s = querys.split("}SQL")
    s = s.select { |sql| sql.upcase.start_with? 'SELECT' }
    result = {:msg => 'ok', :success => true}
    s.each_with_index do |d, count|
      query = d.sub('SQL{','')
      res = ActiveRecord::Base.connection.execute("#{query} " + (maxrows > 0 ? "limit #{maxrows}" : ""))
      result.merge!({"result#{count}" => {:data => res, :sql => query, :maxrows => maxrows }})
    end
    result.merge!({:countResults => s.length})
    render :json => result
  end
  
  
  def export_csv
    query = params[:query]
    maxrows = params[:maxrows].to_i
    res = ActiveRecord::Base.connection.execute("#{query} " + (maxrows > 0 ? "limit #{maxrows}" : ""))
    csv_string = FasterCSV.generate(:col_sep => ";", :row_sep => "\r\n") { |csv|
      csv << res[0].keys
      res.each do |obj|
        csv << obj.values
      end
    }
    outfile = "export_" + Time.now.strftime("%m-%d-%Y") + ".xls"
    send_data csv_string, :type => 'application/vnd.ms-excel; charset=UTF-8; header=present',
                          :disposition => "attachment; filename=#{outfile}"
  end
  
  def save_query_report
    reporte = Reporte.new(params[:reporte])
    reporte.save
    render :json => {:msg => 'ok', :success => true}
  end
  
  def tipos_reportes
    tipos = Reporte.tipos
    result = {:msg => 'ok', :success => true, :tipos => tipos}
    render :json => result
  end
  
end
