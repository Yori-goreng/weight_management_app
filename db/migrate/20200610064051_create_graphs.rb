class CreateGraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :graphs do |t|
      t.integer  :morning_cal
      t.string   :morning_image
      t.integer  :lunch_cal
      t.string   :lunch_image
      t.integer  :dinner_cal
      t.string   :dinner_string
      t.integer  :total_cal
      t.string   :motion
      t.integer  :motion_time
      t.integer  :consumption_cal
      t.float    :weight
      t.timestamps
    end
  end
end