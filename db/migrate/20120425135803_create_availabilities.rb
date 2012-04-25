class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.references :user
      t.datetime :date
      t.boolean :value

      t.timestamps
    end
    add_index :availabilities, :user_id
  end
end
