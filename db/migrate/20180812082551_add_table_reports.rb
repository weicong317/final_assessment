class AddTableReports < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :report
    remove_column :users, :bg_pic

    create_table :reports do |t|
      t.belongs_to :user, index: true
      t.belongs_to :message, index: true
      t.timestamps
    end
  end
end
