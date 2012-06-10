class MultiInstances < ActiveRecord::Migration
  def change
  	# instances table and the references
  	create_table :instances do |t|
      t.string 	:name, :null => false
      t.string 	:defaultLanguage, :null => false, :default => 'en'
      t.boolean :advertising, :null => false, :default => true
      t.boolean :planningTool, :null => false, :default => false

      t.timestamps
    end

    add_column :links, :instance_id, :integer, :null => false, :default => 1
    add_index :links, :instance_id

    add_column :articles, :instance_id, :integer, :null => false, :default => 1
    add_index :articles, :instance_id

    add_column :availabilities, :instance_id, :integer, :null => false, :default => 1
    add_index :availabilities, :instance_id

    add_column :notifications, :instance_id, :integer, :null => false, :default => 1
    add_index :notifications, :instance_id


    # relationships table
    create_table :relationships do |t|
      t.references 	:user, :null => false, :default => 1
      t.references 	:instance, :null => false, :default => 1
      t.boolean		:admin, :null => false, :default => true
    end

    add_index :relationships, :instance_id
    add_index :relationships, :user_id


    # user language, avatar and superadmin flag columns
    add_column :users, :lang, :string, :null => false, :default => 'en'
    add_column :users, :avatar, :string, :null => true
    add_column :users, :superadmin, :string, :null => false, :default => false
    remove_column :users, :login
  end
end
