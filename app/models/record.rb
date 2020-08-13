class Record < ApplicationRecord

  belongs_to :user

  # そのままデータを取り出すと，日付が不連続なデータになるため，日付が連続するデータを作成する。
  def self.chart_data(user)
    # ログインしたユーザの情報を渡す、昇順
    records = user.records.order(record_date: :asc)
    today = Date.today

    # 記録が無い場合にエラーが出るのを防止
    # 全くデータがない場合
    return [{record_date: today}] if records.empty?

    start_date = records.first.record_date
    last_date = records.last.record_date
    # 今日の日付までを対象とする
    if last_date < today
      last_date = today
    end

    # periodに開始日から最終日までを配置
    period = start_date..last_date

    # 配列作成
    chart_data = []
    period.each do |date|
      record = records.find do |record|
        record.record_date == date
      end
      if record.present?
        # 必要なカラムだけを抽出
        chart_data << record.slice(:record_date, :weight, :cal_judge)
      else
        chart_data << {record_date: date, weight: nil, cal_judge: nil}
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