class Event < ApplicationRecord
  has_many :expenses
  has_many :people

  validates_presence_of :name, :start_date, :end_date

  def self.transaction
    Struct.new(
      :amount,
      :receiver
    )
  end
end
