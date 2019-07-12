class Admin::VolunteersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @volunteers = @volunteers.page(params[:page])
  end

  def search
    @users = User.search(params[:name_or_email])
                 .includes(:volunteer)
                 .page(params[:page])
                 .for_render
  end

  def create
    @volunteer.user_id = params[:user_id]
    @volunteer.save

    redirect_to admin_volunteers_path
  end

  def destroy
    @volunteer.destroy
    redirect_to admin_volunteers_path
  end
end
