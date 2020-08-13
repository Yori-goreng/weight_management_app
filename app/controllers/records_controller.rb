class RecordsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @q = Record.ransack(params[:q])
    @records = @q.result(distinct: true).order(record_date: "DESC")

    gon.records = Record.chart_data(User.find_by(id: 1))
    gon.start_date = gon.records.first[:record_date].strftime('%Y-%m-%d')
    gon.end_date = gon.records.last[:record_date].strftime('%Y-%m-%d')
    gon.basal_metabolism = User.find_by(id: 1).basal_metabolism
  end
  
end
