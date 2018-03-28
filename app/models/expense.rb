class Expense < ApplicationRecord
  belongs_to :event
  has_one :purchaser, :class_name => "Person"
  has_and_belongs_to_many :people

  accepts_nested_attributes_for :event, :reject_if => :all_blank
end
