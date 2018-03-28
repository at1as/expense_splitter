class CreateJoinTablePeopleExpenses < ActiveRecord::Migration[5.1]
  def change
    create_join_table :people, :expenses do |t|
      # t.index [:person_id, :expense_id]
      # t.index [:expense_id, :person_id]
    end
  end
end
