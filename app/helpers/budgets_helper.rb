module BudgetsHelper
  def ideas_phases?(budget = current_budget)
    %w[ideas_posting project_forming].include? budget.phase
  end

  def show_links_to_budget_investments(budget)
    ['balloting', 'reviewing_ballots', 'finished'].include? budget.phase
  end

  def show_links_to_unfesable_budget_investments(budget)
    %w[
      reviewing
      selecting
      valuating
      publishing_prices
      balloting
      reviewing_balots
      finished
    ].include? budget.phase
  end

  def heading_name_and_price_html(heading, budget)
    content_tag :div do
      concat(heading.name + ' ')
      concat(content_tag(:span, budget.formatted_heading_price(heading)))
    end
  end

  def csv_params
    csv_params = params.clone.merge(format: :csv).symbolize_keys
    csv_params.delete(:page)
    csv_params
  end

  def budget_phases_select_options
    Budget::Phase.phase_kinds.map { |ph| [ t("budgets.phase.#{ph}"), ph ] }
  end

  def budget_currency_symbol_select_options
    Budget::CURRENCY_SYMBOLS.map { |cs| [ cs, cs ] }
  end

  def kind_sensitive_budget_investments_path(budget, options = {})
    if budget.ideas_posting?
      budget_ideas_path(budget, options)
    else
      budget_investments_path(budget, options)
    end
  end

  def namespaced_budget_investment_path(investment, options = {})
    key = "#{namespace}##{investment.kind}"

    case key
    when "management/budgets#project"
      management_budget_investment_path(investment.budget, investment, options)
    when "management/budgets#idea"
      management_budget_idea_path(investment.budget, investment, options)
    when "budgets#idea"
      budget_idea_path(investment.budget, investment, options)
    else
      budget_investment_path(investment.budget, investment, options)
    end
  end

  def namespaced_budget_investment_vote_path(investment, options = {})
    key = "#{namespace}##{investment.kind}"

    case key
    when "management/budgets#project"
      vote_management_budget_investment_path(investment.budget, investment, options)
    when "management/budgets#idea"
      vote_management_budget_idea_path(investment.budget, investment, options)
    when "budgets#idea"
      vote_budget_idea_path(investment.budget, investment, options)
    else
      vote_budget_investment_path(investment.budget, investment, options)
    end
  end

  def display_budget_countdown?(budget)
    budget.balloting?
  end

  def css_for_ballot_heading(heading)
    return '' if current_ballot.blank?
    current_ballot.has_lines_in_heading?(heading) ? 'is-active' : ''
  end

  def current_ballot
    Budget::Ballot.where(user: current_user, budget: @budget).first
  end

  def investment_tags_select_options(budget)
    Budget::Investment.by_budget(budget).tags_on(:valuation).order(:name).select(:name).distinct
  end

  def idea_tags_select_options(budget)
    Budget::Investment.by_budget(budget).idea.tags_on(:tags).order(:name).select(:name).distinct
  end

  def idea_published_select_options
    [['Published', true], ['Not Published', false]]
  end

  def idea_map_select_options
    [['Yes', true], ['No', false]]
  end

  def budget_published?(budget)
    !budget.drafting? || current_user&.administrator?
  end

  def current_budget_map_locations
    return unless current_budget.present?
    if current_budget.ideas_posting?
      investments = current_budget.investments.idea.published
    elsif current_budget.valuating_or_later?
      investments = current_budget.investments.project.selected
    else
      investments = current_budget.investments.project
    end

    MapLocation.where(investment_id: investments).map { |l| l.json_data }
  end

  def display_calculate_winners_button?(budget)
    budget.balloting_or_later?
  end

  def calculate_winner_button_text(budget)
    if budget.investments.winners.empty?
      t("admin.budgets.winners.calculate")
    else
      t("admin.budgets.winners.recalculate")
    end
  end

  def current_budget_ideas_posting_url
    if current_budget.post_idea_uri.to_s.empty?
      new_budget_idea_path(current_budget)
    else
      current_budget.post_idea_uri
    end
  end

  def budget_idea_title_by_heading(heading_name)
    if current_budget_phase.title
      "#{current_budget_phase.title}: #{heading_name}"
    else
      t("budgets.ideas.index.by_heading", heading: heading_name)
    end
  end

end
