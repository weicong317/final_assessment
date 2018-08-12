class AddColumnToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :delete_request, :string
  end
end
