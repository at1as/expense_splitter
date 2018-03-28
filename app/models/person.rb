class Person < ApplicationRecord
  has_one :event
  has_and_belongs_to_many :expenses
end
