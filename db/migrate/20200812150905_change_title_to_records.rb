class ChangeTitleToRecords < ActiveRecord::Migration[5.2]
  def change
    change_column :records, :weight, :float
  end
end
