class Budget::Investment::Importer
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :budget_id, :heading_id, :file, :default_author_id

  validates :budget_id, presence: true
  validates :heading_id, presence: true
  validates :file_id, presence: true

  validates :budget, presence: true
  validates :heading, presence: true

  def budget
    Budget.find_by_id(budget_id)
  end

  def heading
    budget&.headings&.find_by_id(heading_id)
  end

  def import
    return unless valid?
  end

  def default_author
    User.find_by_username(default_author_id)
  end
end
