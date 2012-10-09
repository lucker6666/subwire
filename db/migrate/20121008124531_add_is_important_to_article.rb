class AddIsImportantToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :is_important, :boolean, :default => false
  end
end
