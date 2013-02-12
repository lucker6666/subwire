class AddPermalinkToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :permalink, :string
    add_index :channels, :permalink

    Channel.find(:all).each do |c|
      c.generate_permalink!
      c.save!
    end
  end
end