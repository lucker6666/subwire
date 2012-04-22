class Notifications < ActiveRecord::Migration
  def change
  	create_table :notifictations do |t|
      t.string :type, :default => "article"
      t.string :message
      t.string :href
      t.boolean :is_read

      t.references :user

      t.timestamps
    end
  end
end
