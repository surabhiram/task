class Person < ActiveRecord::Base
  belongs_to :house
  attr_accessible :age, :gender, :house_id, :mob, :name

  validates :name, presence: true, length: {maximum: 30}
  VALID_MOB_REGEX = /\A[0-9]+\z/
  validates :mob, presence: true, format: { with: VALID_MOB_REGEX },length: { maximum: 10, minimum: 10}
  validates :age, presence: true
end
