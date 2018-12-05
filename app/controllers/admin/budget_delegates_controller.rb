class Admin::BudgetDelegatesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @budget_delegates = @budget_delegates.page(params[:page])
  end

  def search
    @users = User.search(params[:name_or_email])
                 .includes(:budget_delegate)
                 .page(params[:page])
                 .for_render
  end

  def create
    @budget_delegate.user_id = params[:user_id]
    @budget_delegate.save

    redirect_to admin_budget_delegates_path
  end

  def destroy
    if current_user.id == @budget_delegate.user_id
      flash[:error] = I18n.t("admin.budget_delegates.budget_delegate.restricted_removal")
    else
      @budget_delegate.destroy
    end

    redirect_to admin_budget_delegates_path
  end
end
