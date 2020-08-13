class Graph < ApplicationRecord
  belongs_to :user

  def self.chart_data(user)
  graphs = user.graphs.order(graph_date: :asc)
  today = Date.today

  # 記録が無い場合にエラーが出るのを防止
  # 全くデータがない場合
  return [{date: today}] if graphs.empty?

  start_date = graphs.first.graph_date
  last_date = graphs.last.graph_date
  # 今日の日付までを対象とする
  if last_date < today
    last_date = today
  end

  # periodに開始日から最終日までを配置
  period = start_date..last_date

  # 配列作成
  chart_data = []
  period.each do |date|
    graph = graphs.find do |graph|
      graph.graph_date == date
    end
    if graph.present?
      # 必要なカラムだけを抽出
      chart_data << graph.slice(:graph_date, :weight, :cal_judge)
    else
      chart_data << {date: date, weight: nil, cal_judge: nil}
    end
  end
  # 戻り値
  chart_data
end

before_save do
  self.intake_cal = morning_cal+lunch_cal+dinner_cal
  self.total_consumption_cal = consumption1_cal+consumption2_cal+consumption3_cal
  self.cal_judge = intake_cal - total_consumption_cal
end

end