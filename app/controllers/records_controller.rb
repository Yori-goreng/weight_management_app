class RecordsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @q = Record.ransack(params[:q])
    @records = @q.result(distinct: true).order(date: "DESC")

    gon.records = Record.chart_data(User.find_by(id: 1))
    gon.start_date = gon.records.first[:date].strftime('%Y-%m-%d')
    gon.end_date = gon.records.last[:date].strftime('%Y-%m-%d')
    gon.basal_metabolism = User.find_by(id: 1).basal_metabolism
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.user_id = current_user.id
    if @record.save
      redirect_to("/records")
    else
      render(new_record_path)
    end
  end

  private

  def record_params
    params.require(:record).permit(:date, :morning_cal, :morning_image, :lunch_cal, :lunch_image, :dinner_cal, :dinner_image, :motion1, :motion1_hour, :motion1_minute, :consumption1_cal, :motion2, :motion2_hour, :motion2_minute, :consumption2_cal, :motion3, :motion3_hour, :motion3_minute, :consumption3_cal, :weight)
  end

  def params_record_search
    params.permit(:search_weight)
  end

end
