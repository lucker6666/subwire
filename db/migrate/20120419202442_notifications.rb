class Notifications < ActiveRecord::Migration
  def change
  	create_table :notifications do |t|
      t.string :notification_type, :default => "article"
      t.string :message
      t.string :href
      t.boolean :is_read

      t.references :user

      t.timestamps
    end
  end
end
