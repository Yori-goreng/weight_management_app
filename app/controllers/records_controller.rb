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

end
