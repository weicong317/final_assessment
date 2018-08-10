class MessageColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message, :text
  end
end
