class Budget::Investment::Importer
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :budget_id, :heading_id, :file

  validates :budget_id, presence: true
  validates :heading_id, presence: true
  validates :file, presence: true
end
