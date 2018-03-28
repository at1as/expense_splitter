class AddEventToPerson < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :event, foreign_key: true
  end
end
