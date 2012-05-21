class MultiInstances < ActiveRecord::Migration
  def change
  	# instances table
  	create_table :instances do |i|
      t.string 	:name, :null => false
      t.string 	:defaultLanguage, :null => false, :default => 'en'
      t.boolean :advertising, :null => false, :default => true
      t.boolean :planningTool, :null => false, :default => false

      t.timestamps
    end

    add_column :links, :instance_id, :integer, :null => false
    add_index :links, :instance_id

    add_column :articles, :instance_id, :integer, :null => false
    add_index :articles, :instance_id

    # relationships table
    create_table :relationships do |t|
      t.references 	:user, :null => false
      t.references 	:instance, :null => false
      t.boolean			:admin, :null => false, :default => false
    end
    add_index :relationships, :instance_id
    add_index :relationships, :user_id

    # article types
    add_column :articles, :type, :string, :null => false, :default => 'article'

    # user language and avatar columns
    add_column :users, :lang, :string, :null => false, :default => 'en'
    add_column :users, :avatar, :string, :null => false
  end
end
