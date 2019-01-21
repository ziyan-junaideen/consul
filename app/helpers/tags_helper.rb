module TagsHelper
  def kind_safe_taggables_path(taggable, tag_name)
    if taggable.is_a? Budget::Investment
      taggables_path("budget/investment##{taggable.kind}", tag_name)
    else
      taggable_type = taggable.class.name.underscore
      taggables_path(taggable_type, tag_name)
    end
  end

  def taggables_path(taggable_type, tag_name)
    case taggable_type
    when 'debate'
      debates_path(search: tag_name)
    when 'proposal'
      proposals_path(search: tag_name)
    when 'budget/investment#idea'
      budget_ideas_path(@budget, search: tag_name)
    when 'budget/investment#project'
      budget_investments_path(@budget, search: tag_name)
    when 'budget/investment'
      kind_sensitive_budget_investments_path(@budget, search: tag_name)
    when 'legislation/proposal'
      legislation_process_proposals_path(@process, search: tag_name)
    else
      '#'
    end
  end

  def taggable_path(taggable)
    taggable_type = taggable.class.name.underscore
    case taggable_type
    when 'debate'
      debate_path(taggable)
    when 'proposal'
      proposal_path(taggable)
    when 'budget/investment'
      budget_investment_path(taggable.budget_id, taggable)
    when 'legislation/proposal'
      legislation_process_proposal_path(@process, taggable)
    else
      '#'
    end
  end

end
