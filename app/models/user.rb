class User < ActiveRecord::Base

  has_secure_password validations: false

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, on: :create
  validates :full_name, presence: true

  has_many :queue_items

end