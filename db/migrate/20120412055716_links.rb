class Links < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :name
      t.string :href
      t.string :icon

      t.timestamps
    end
  end
end
