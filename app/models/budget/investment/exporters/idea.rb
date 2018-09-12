class Budget::Investment::Exporters::Idea < Budget::Investment::Exporters::Base
  private

  def headers
    [
      I18n.t("admin.budget_ideas.index.list.budget_id"),
      I18n.t("admin.budget_ideas.index.list.id"),
      I18n.t("admin.budget_ideas.index.list.title"),
      I18n.t("admin.budget_ideas.index.list.supports"),
      I18n.t("admin.budget_ideas.index.list.admin"),
      I18n.t("admin.budget_ideas.index.list.valuator"),
      I18n.t("admin.budget_ideas.index.list.valuation_group"),
      I18n.t("admin.budget_ideas.index.list.geozone"),
      I18n.t("admin.budget_ideas.index.list.feasibility"),
      I18n.t("admin.budget_ideas.index.list.valuation_finished"),
      I18n.t("admin.budget_ideas.index.list.selected"),
      I18n.t("admin.budget_ideas.index.list.visible_to_valuators"),
      I18n.t("admin.budget_ideas.index.list.author_username"),
      I18n.t("admin.budget_ideas.index.list.created_at"),
      I18n.t("admin.budget_ideas.index.list.description"),
      I18n.t("admin.budget_ideas.index.list.tags"),
      I18n.t("admin.budget_ideas.index.map_latitude"),
      I18n.t("admin.budget_ideas.index.map_longitude")
    ]
  end

  def csv_values(investment)
    [
      investment.budget.id,
      investment.id.to_s,
      investment.title,
      investment.total_votes.to_s,
      admin(investment),
      investment.assigned_valuators || '-',
      investment.assigned_valuation_groups || '-',
      investment.heading.name,
      price(investment),
      investment.valuation_finished? ? I18n.t('shared.yes') : I18n.t('shared.no'),
      investment.selected? ? I18n.t('shared.yes') : I18n.t('shared.no'),
      investment.visible_to_valuators? ? I18n.t('shared.yes') : I18n.t('shared.no'),
      investment.author.username,
      investment.created_at,
      investment.description,
      investment.tag_list.join(','),
      investment.map_location&.latitude,
      investment.map_location&.longitude
    ]
  end
end
