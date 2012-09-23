class Dates < ActiveRecord::Migration
  def change
    remove_column :availabilities, :created_at
    remove_column :availabilities, :updated_at
    change_column :availabilities, :date, :date
  end
end
