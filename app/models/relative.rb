class Relative < ActiveRecord::Base
  UPDATABLE_ATTRIBUTES = %w{times_reported hidden}

  validates :first_relative_id, presence: true
  validates :second_relative_id, presence: true
  validates :second_relative_id, presence: true
  validates :second_relative_type, presence: true

  after_save :save_duplicated, unless: :already_duplicated?
  after_update :update_duplicated, unless: :is_duplicated_updated?
  after_destroy :destroy_duplicated, if: :already_duplicated?

  def save_duplicated
    duplicated = Relative.where(id: self.duplicated_id).first
    if !duplicated.present?
      Relative.create!(accepted_attributes)
    else
      duplicated.update!(duplicated_id: self.id)
    end
  end

  def update_duplicated
    get_duplicated.update!(accepted_attributes)
  end

  def destroy_duplicated
    get_duplicated.destroy!
  end

  def report
    self.increment!(:times_reported)
    self.update!(hidden: true) if self.times_reported >= 5
  end

  private

  def get_duplicated
    Relative.find_by(duplicated_id: self.id)
  end

  def is_duplicated_updated?
    UPDATABLE_ATTRIBUTES.map { |a| self[a] === get_duplicated[a] }.all?
  end

  def already_duplicated?
    get_duplicated.present?
  end

  def accepted_attributes
    {
      first_relative_id: self.second_relative_id,
      second_relative_id: self.first_relative_id,
      first_relative_type: self.second_relative_type,
      second_relative_type: self.first_relative_type,
      duplicated_id: self.id
    }
  end

end
