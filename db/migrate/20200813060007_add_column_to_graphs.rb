class AddColumnToGraphs < ActiveRecord::Migration[5.2]
  def change
    add_column :graphs, :user_id, :integer
    add_column :graphs, :dinner_image, :string
    add_column :graphs, :intake_cal, :integer
    add_column :graphs, :motion1, :string
    add_column :graphs, :motion1_hour, :integer
    add_column :graphs, :motion1_minute, :integer
    add_column :graphs, :motion2, :string
    add_column :graphs, :motion2_hour, :integer
    add_column :graphs, :motion2_minute, :integer
    add_column :graphs, :motion3, :string
    add_column :graphs, :motion3_hour, :integer
    add_column :graphs, :motion3_minute, :integer
    add_column :graphs, :cal_judge, :integer
    add_column :graphs, :graph_date, :date
  end
end
