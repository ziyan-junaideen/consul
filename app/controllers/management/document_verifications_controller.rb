class Management::DocumentVerificationsController < Management::BaseController

  before_action :clean_document_number, only: :check
  before_action :set_document, only: :check

  def index
    @document_verification = Verification::Management::Document.new
  end

  def check
    @document_verification = Verification::Management::Document.new(document_verification_params)
    if params[:document_verification][:document_type] == 'username'
      user = User.find_by_username(params[:document_verification][:document_number])

      if user
        flash[:notice] = t('management.document_verifications.managed_user_by_username')
        redirect_to action: :index
      else
        flash.now[:alert] = t('management.document_verifications.managed_user_by_username_not_found')
        render :index
      end
    elsif @document_verification.valid?
      if @document_verification.verified?
        render :verified
      elsif @document_verification.user?
        render :new
      elsif @document_verification.in_census?
        redirect_to new_management_email_verification_path(email_verification: document_verification_params)
      else
        render :invalid_document
      end
    else
      render :index
    end
  end

  def create
    @document_verification = Verification::Management::Document.new(document_verification_params)
    @document_verification.verify
    render :verified
  end

  private

    def document_verification_params
      params.require(:document_verification).permit(:document_type, :document_number)
    end

    def set_document
      session[:document_type] = params[:document_verification][:document_type]
      session[:document_number] = params[:document_verification][:document_number]
      clear_password
    end

    def clean_document_number
      return if params[:document_verification][:document_number].blank?
      return if params[:document_verification][:document_type] == 'username'
      params[:document_verification][:document_number] = params[:document_verification][:document_number].gsub(/[^a-z0-9]+/i, "").upcase
    end

end
