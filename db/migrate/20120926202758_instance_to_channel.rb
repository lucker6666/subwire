class InstanceToChannel < ActiveRecord::Migration
  def change
    rename_column :articles, :instance_id, :channel_id
    remove_index :articles, :column => :instance_id
    add_index :articles, [:channel_id], :name => "index_articles_on_channel_id"


    rename_column :availabilities, :instance_id, :channel_id
    remove_index :availabilities, :column => :instance_id
    add_index :availabilities, [:channel_id], :name => "index_availabilities_on_channel_id"

    rename_table :instances, :channels

    rename_column :links, :instance_id, :channel_id
    remove_index :links, :column => :instance_id
    add_index :links, [:channel_id], :name => "index_links_on_channel_id"

    rename_column :notifications, :instance_id, :channel_id
    remove_index :notifications, :column => :instance_id
    add_index :notifications, [:channel_id], :name => "index_notifications_on_channel_id"

    rename_column :relationships, :instance_id, :channel_id
    remove_index :relationships, :column => :instance_id
    add_index :relationships, [:channel_id], :name => "index_relationships_on_channel_id"
  end
end
