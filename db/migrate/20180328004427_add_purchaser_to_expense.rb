class AddPurchaserToExpense < ActiveRecord::Migration[5.1]
  def change
    add_reference :expenses, :purchaser, foreign_key: { to_table: :people }
  end
end
