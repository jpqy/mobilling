class V1::DiagnosesController < V1::BaseController
  skip_before_action :require_user, only: %i[index]
  skip_before_action :refresh_session, only: %i[index]
  resource_description { resource_id "diagnoses" }

  api :GET, "/v1/diagnoses", "Returns diagnoses"

  def pundit_user
    nil
  end

  def index
    expires_in 7.days, public: true
    @diagnoses = policy_scope(Diagnosis).pluck(:name)
    render json: @diagnoses
  end
end
