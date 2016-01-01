class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :external_id
      t.string :real_name
      t.string :image_url

      t.timestamps null: false
    end
    add_index :users, :external_id, unique: true
  end
end
