class AddIndexes < ActiveRecord::Migration
  def change
    add_index :articles, [:user_id], name: "index_articles_on_user_id"
    add_index :comments, [:user_id], name: "index_comments_on_user_id"
    add_index :comments, [:article_id], name: "index_comments_on_article_id"
    add_index :notifications, [:user_id], name: "index_notifications_on_user_id"
  end
end
