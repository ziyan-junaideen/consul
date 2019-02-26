module AdminBudgetsHelper
  def budget_submit_button_text
    if @budget.persisted?
      t('admin.budgets.form.submit.update')
    else
      t('admin.budgets.form.submit.create')
    end
  end
end
