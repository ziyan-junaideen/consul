module FollowsHelper

  def follow_text(followable)
    entity = followable.class.name.underscore
    t("shared.follow_entity", entity: t("activerecord.models.#{entity}.one").downcase)
  end

  def unfollow_text(followable)
    entity = followable.class.name.underscore
    t("shared.unfollow_entity", entity: t("activerecord.models.#{entity}.one").downcase)
  end

  private

  def followable_entity(followable)
    if followable.is_a?(Budget::Investment) && followable.idea?
      'budget/idea'
    else
      followable.class.name.underscore
    end
  end

end
