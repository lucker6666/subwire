class AddPositionToLink < ActiveRecord::Migration
  def change
    add_column :links, :position, :integer, :default => 0

    Link.find(:all, :select => :channel_id, :group => :channel_id).each do |c|
      Link.where("channel_id = ?", c.channel_id).order("id").each_with_index do |l, idx|
        l.position = idx + 1
        l.save!
      end
    end
  end
end
