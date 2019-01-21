class BudgetDelegate < ActiveRecord::Base
  belongs_to :user
  delegate :name, :email, :name_and_email, to: :user

  validates :user_id, presence: true, uniqueness: true
end
