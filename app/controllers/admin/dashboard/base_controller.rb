class Admin::Dashboard::BaseController < Admin::BaseController
  helper_method :namespace

  private

    def namespace
      "admin"
    end
end
