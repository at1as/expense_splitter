class Event < ApplicationRecord
  has_many :expenses
  has_many :people

  def self.transaction
    Struct.new(
      :amount,
      :receiver
    )
  end
end
