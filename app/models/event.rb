class Event < ApplicationRecord
  has_many :expenses
  has_many :people

  validates_presence_of :name, :start_date, :end_date

  class << self
    def monetary_transaction
      Struct.new(
        :amount,
        :receiver
      )
    end
  end
end
