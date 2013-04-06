class RemoveIcon < ActiveRecord::Migration
  def change
    remove_column :links, :icon
  end
end
