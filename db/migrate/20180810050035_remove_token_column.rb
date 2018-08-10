class RemoveTokenColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column(:authentications, :token)
  end
end
