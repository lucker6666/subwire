class Timezone < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string, :null => false, :default => 'Central Time (US & Canada)'
  end
end
