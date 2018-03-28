class Event < ApplicationRecord
  has_many :expenses
  has_many :people
end
