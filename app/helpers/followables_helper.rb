module FollowablesHelper

  def followable_type_title(followable_type)
    t("activerecord.models.#{followable_type.underscore}.other")
  end

  def followable_icon(followable)
    {
      proposals: 'Proposal',
      budget: 'Budget::Investment'
    }.invert[followable]
  end

  def render_follow(follow)
    return unless follow.followable.present?

    followable = follow.followable
    partial = followable_class_name(followable) + "_follow"
    locals = {followable_class_name(followable).to_sym => followable}

    render partial, locals
  end

  def followable_class_name(followable)
    if followable.is_a?(Budget::Investment) && followable.idea?
      'budget_idea'
    else
      followable.class.to_s.parameterize('_')
    end
  end

  def find_or_build_follow(user, followable)
    Follow.find_or_initialize_by(user: user, followable: followable)
  end

end
