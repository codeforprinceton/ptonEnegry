class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @found = current_user.UserSubmitted
    @gasfound = @found.where.not(gas_reading: nil, bill_date: nil).order(:bill_date)
    @gasusage = @gasfound.pluck(:gas_reading)
    @gaslabels = @gasfound.pluck(:bill_date)
  end

  def show
  end
  
  def history
    @found = current_user.UserSubmitted.where.not(bill_date: nil).order(:bill_date)
  end
  
  def add
    @submitted = UserSubmitted.new
  end
  
  def update
    @submitted = UserSubmitted.new(user_submitted_params)
    @submitted[:user_id] = current_user.id
    unless params[:user_submitted]["bill_date(1i)"].present? and params[:user_submitted]["bill_date(2i)"].present? and params[:user_submitted]["bill_date(3i)"].present?
      flash[:alert] = "Error saving, date required"
      return render :add
    end
    @submitted[:bill_date] = Date.civil(params[:user_submitted]["bill_date(1i)"].to_i,
                         params[:user_submitted]["bill_date(2i)"].to_i,
                         params[:user_submitted]["bill_date(3i)"].to_i)
    if @submitted.save
      flash[:notice] = "Saved successfully"
      return redirect_to dashboard_path
    else
      flash[:alert] = "Error saving"
      return render :add
    end
  end
  
  def delete
    entry = UserSubmitted.find(params[:id])
    if entry.user_id == current_user.id
      entry.destroy
      flash[:notice] = "Successfully deleted entry"
      return redirect_to dashboard_history_path
    else
      flash[:alert] = "Delete not authorized"
      return redirect_to root_path
    end

  end
  
  private
  
  def user_submitted_params
    params.require(:user_submitted).permit(:user_id, :bill_date, :electric_reading, :electric_charge, :gas_reading, :gas_charge, :city, :state, :zip)
  end
end
