class Comments < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
      t.string :content

      t.references :user
      t.references :article

      t.timestamps
    end
  end
end
