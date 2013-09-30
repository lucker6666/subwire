class RenamePagesToWikis < ActiveRecord::Migration
  def change
    rename_table :pages, :wikis
  end
end
