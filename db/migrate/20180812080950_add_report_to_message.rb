class AddReportToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :report, :integer, :default => 0
  end
end
