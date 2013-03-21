class IsHome < ActiveRecord::Migration
  def change
    add_column :pages, :is_home, :boolean, null: false, default: false
  end
end
