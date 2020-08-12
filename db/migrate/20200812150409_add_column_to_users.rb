class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :age, :integer
    add_column :users, :name, :string
    add_column :users, :gender, :string
    add_column :users, :user_image, :string
    add_column :users, :height, :float
    add_column :users, :weight, :float
    add_column :users, :basal_metabolism, :float
  end
end
