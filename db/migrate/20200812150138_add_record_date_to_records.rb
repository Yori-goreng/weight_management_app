class AddRecordDateToRecords < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :record_date, :date
  end
end
