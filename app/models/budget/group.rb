class Budget
  class Group < ActiveRecord::Base
    include Sluggable

    translates :name, touch: true
    include Globalizable

    belongs_to :budget

    has_many :headings, dependent: :destroy

    before_validation :assign_model_to_translations

    validates_translation :name, presence: true
    validates :budget_id, presence: true
    validates :slug, presence: true, format: /\A[a-z0-9\-_]+\z/
    validates :voting_style, inclusion: { in: Vote::KINDS }
    validates :number_votes_per_heading, :numericality => { greater_than_or_equal_to: 1 }

    scope :sort_by_name, -> { includes(:translations).order(:name) }
    scope :approval_voting, -> { where(voting_style: 'approval') }

    def single_heading_group?
      headings.count == 1
    end

    def approval_voting?
      voting_style == "approval"
    end

    private

    def generate_slug?
      slug.nil? || budget.drafting?
    end

  end
end
