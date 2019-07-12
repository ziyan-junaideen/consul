module BudgetInvestmentsHelper
  def budget_investments_advanced_filters(params)
    params.map { |af| t("admin.budget_investments.index.filters.#{af}") }.join(", ")
  end

  def link_to_investments_sorted_by(column)
    direction = set_direction(params[:direction])
    icon = set_sorting_icon(direction, column)

    translation = t("admin.budget_investments.index.list.#{column}")

    link_to(
      "#{translation} <span class='icon-sortable #{icon}'></span>".html_safe,
      admin_budget_budget_investments_path(sort_by: column, direction: direction)
    )
  end

  def set_sorting_icon(direction, sort_by)
    if sort_by.to_s == params[:sort_by]
      if direction == "desc"
        "desc"
      else
        "asc"
      end
    else
      ""
    end
  end

  # alias_method :budget_ideas_sorting_options, :budget_investments_sorting_options

  def budget_investments_advanced_filters(params)
    params.map { |af| t("admin.budget_investments.index.filters.#{af}") }.join(', ')
  end
  
  def set_direction(current_direction)
    current_direction == "desc" ? "asc" : "desc"
  end

  def investments_minimal_view_path
    budget_investments_path(id: @heading.group.to_param,
                            heading_id: @heading.to_param,
                            filter: @current_filter,
                            view: investments_secondary_view)
  end

  def investments_default_view?
    @view == "default"
  end

  def investments_current_view
    @view
  end

  def investments_secondary_view
    investments_current_view == "default" ? "minimal" : "default"
  end

  def unfeasible_summary(budget)
    count = budget.investments.project.unfeasible.count
    case count
    when 0
      t('budgets.investments.index.unfeasible_summary_none')
    when 1
      t('budgets.investments.index.unfeasible_summary_one')
    else
      t('budgets.investments.index.unfeasible_summary_many', count: count)
    end
  end
end
