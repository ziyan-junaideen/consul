class Budget::Investment::Exporters::Base
  require 'csv'

  def initialize(investments)
    @investments = investments
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << headers
      @investments.each { |investment| csv << csv_values(investment) }
    end
  end

  protected

  def headers
    raise NotImplementedError
  end

  def csv_values(investment)
    raise NotImplementedError
  end
  
  def admin(investment)
    if investment.administrator.present?
      investment.administrator.name
    else
      I18n.t("admin.budget_investments.index.no_admin_assigned")
    end
  end

  def price(investment)
    price_string = "admin.budget_investments.index.feasibility.#{investment.feasibility}"
    I18n.t(price_string, price: investment.formatted_price)
  end
end
