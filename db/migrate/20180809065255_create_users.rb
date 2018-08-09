class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.integer :role, default: 0
      t.string :bg_pic
      t.timestamps
    end
  end
end
