module RelatedContentsHelper
  def related_content_title_i18n_key(related)
    if related.is_a?(Budget::Investment) && related.idea?
      'budget_idea'
    else
      related.model_name.singular
    end
  end
end
