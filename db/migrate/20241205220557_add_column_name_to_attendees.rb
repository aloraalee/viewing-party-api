class AddColumnNameToAttendees < ActiveRecord::Migration[7.1]
  def change
    add_column :attendees, :is_host, :boolean
  end
end
