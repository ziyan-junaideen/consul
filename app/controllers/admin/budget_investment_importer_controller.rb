class Admin::BudgetInvestmentImporterController < ApplicationController
  def new
    @importer = Budget::Investment::Importer.new
  end

  def create
    @importer = Budget::Investment::Importer.new(importer_attributes)
    if @importer.valid?
      @importer.import
      flash[:notice] = 'Import complete'
      render :report
    else
      flash[:notice] = 'Please check form for errors'
      render :new
    end
  end

  private

  def importer_attributes
    params.require(:budget_investment_importer).permit(:budget_id, :heading_id, :default_author_id, :file)
  end
end
