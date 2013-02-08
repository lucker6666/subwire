class ArticlesToMessages < ActiveRecord::Migration
  def change
    remove_index :articles, column: :user_id
    remove_index :articles, column: :channel_id
    rename_table :articles, :messages
    add_index :messages, [:channel_id], name: "index_messages_on_channel_id"
    add_index :messages, [:user_id], name: "index_messages_on_user_id"

    remove_index :comments, column: :article_id
    rename_column :comments, :article_id, :message_id
    add_index :comments, [:message_id], name: "index_comments_on_message_id"

    change_column :notifications, :notification_type, :string, :default => "message"
  end
end
