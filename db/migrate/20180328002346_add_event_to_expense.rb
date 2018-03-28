class AddEventToExpense < ActiveRecord::Migration[5.1]
  def change
    add_reference :expenses, :event, foreign_key: true
  end
end
