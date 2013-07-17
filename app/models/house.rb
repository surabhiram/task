class House < ActiveRecord::Base
  has_many :people
  attr_accessible :address, :num_of_ppl

  validates :address, presence: true

  validates :num_of_ppl, presence: true, :inclusion => { :in => 0..100 }

end
