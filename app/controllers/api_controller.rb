class ApiController < ApplicationController
  def index
  end
  
  def raw
      @alldata = Reading.all
      return render :json => @alldata.to_json(:except => [:created_at, :updated_at, :id])
  end
  
  def rawtemp
      @alldata = Temperature.all.only(:date, :temp)
      return render :json => @alldata.to_json(:except => [:created_at, :updated_at, :id])
  end
  
  def geojson
      @data = File.read("#{Rails.root}/public/princeton.geojson.json").html_safe
      return render :json => @data
  end
  
  def models
  end
end
