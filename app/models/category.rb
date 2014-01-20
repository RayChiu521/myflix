class Category < ActiveRecord::Base

	has_many :videos, -> { order('title') }

  validates :title, presence: true, uniqueness: true

end