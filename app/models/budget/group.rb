class Budget
  class Group < ApplicationRecord
    include Sluggable

    translates :name, touch: true
    include Globalizable
    translation_class_delegate :budget

    class Translation
      validate :name_uniqueness_by_budget

      def name_uniqueness_by_budget
        if budget.groups.joins(:translations)
                        .where(name: name)
                        .where.not("budget_group_translations.budget_group_id": budget_group_id).any?
          errors.add(:name, I18n.t("errors.messages.taken"))
        end
      end
    end

    belongs_to :budget

    has_many :headings, dependent: :destroy

    before_validation :assign_model_to_translations

    validates_translation :name, presence: true
    validates :budget_id, presence: true
    validates :slug, presence: true, format: /\A[a-z0-9\-_]+\z/
    validates :voting_style, inclusion: { in: Vote::KINDS }
    validates :number_votes_per_heading, :numericality => { greater_than_or_equal_to: 1 }

    def self.sort_by_name
      all.sort_by(&:name)
    end

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
