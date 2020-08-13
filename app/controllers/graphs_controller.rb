class GraphsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @q = Graph.ransack(params[:q])
    @graphs = @q.result(distinct: true).order(record_date: "DESC")

    gon.weight_records = Graph.chart_data(current_user)
    gon.recorded_dates = current_user.graphs.map(&:date)
    gon.records = Graph.chart_data(User.find_by(id: 1))
    gon.start_date = gon.records.first[:record_date].strftime('%Y-%m-%d')
    gon.end_date = gon.records.last[:record_date].strftime('%Y-%m-%d')
    gon.basal_metabolism = User.find_by(id: 1).basal_metabolism
  end

  def create
      @graph = current_user.graphs.build(graph_params)
      @graph = Graph.new
      date = @graph.date.strftime('%Y/%-m/%-d')
      if @graph.save
        flash[:notice] = "#{date}の記録を追加しました"
      else
        flash[:alert] = 'エラーが発生しました'
      end
      redirect_to root_path
  end

  def new
    @graph = Graph.new
  end

  def create
    @graph = Graph.new(graph_params)
    @graph.user_id = current_user.id
    if @graph.save
      redirect_to("/graphs")
    else
      render(new_graph_path)
    end
  end

  def update
    @graph = current_user.graphs.find_by(date: params[:graph][:date])
    date = @graph.date.strftime('%Y/%-m/%-d')
    if @graph.nil?
      flash[:alert] = 'エラーが発生しました'
    elsif params[:_destroy].nil? && @graph.update(graph_params)
      flash[:notice] = "#{date}の記録を修正しました。"
    elsif params[:_destroy].present? && @graph.destroy
      flash[:alert] = "#{date}の記録を削除しました。"
    else
      flash[:alert] = 'エラーが発生しました'
    end
    redirect_to root_path
  end

  def new_guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
  end

  private

  def graph_params
    params.require(:graph).permit(:date, :record_date, :morning_cal, :morning_image, :lunch_cal, :lunch_image, :dinner_cal, :dinner_image, :motion1, :motion1_hour, :motion1_minute, :consumption1_cal, :motion2, :motion2_hour, :motion2_minute, :consumption2_cal, :motion3, :motion3_hour, :motion3_minute, :consumption3_cal, :weight)
  end

  def params_graph_search
    params.permit(:search_weight)
  end
end
