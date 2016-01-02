class AddPostedAtToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :posted_at, :datetime
  end
end
