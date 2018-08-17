module RelatedContentsHelper
  def related_content_title_i18n_key(relationable)
    if budget_idea?(relationable)
      'budget_idea'
    else
      relationable.model_name.singular
    end
  end

  def related_content_types(relationable)
    if budget_idea?(relationable)
      t('related_content.content_title').select { |k, _| %i[proposal budget_idea].include?(k) }.values.to_sentence
    else
      t('related_content.content_title').values.to_sentence
    end
  end

  private

  def budget_idea?(relationable)
    relationable.is_a?(Budget::Investment) && relationable.idea?
  end
end
