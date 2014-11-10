class V1::ClaimsController < V1::BaseController
  wrap_parameters :claim, include: [:status, :photo_id, :patient_name, :hospital, :referring_physician, :diagnoses, :procedure_on, :admission_on, :first_seen_on, :first_seen_consult, :last_seen_on, :most_responsible_physician, :last_seen_discharge, :icu_transfer, :consult_type, :consult_time_in, :consult_time_out, :consult_premium_visit, :consult_premium_first, :consult_premium_travel, :daily_details, :comment, :specialty, :patient_number, :patient_province, :patient_birthday, :patient_sex, :referring_laboratory, :payment_program, :payee, :manual_review_indicator], format: :json
  resource_description { resource_id "claims" }

  api :GET, "/v1/claims", "Returns claims"

  def index
    claims_for_json = current_user.claims.map do |claim|
      claim.for_json(false)
    end
    render json: claims_for_json
  end

  api :GET, "/v1/claims/:id", "Returns a claim"

  def show(claim = nil)
    claim ||= current_user.claims.includes(:comments).find(params[:id])
    render json: claim.for_json(true)
  end

  api :POST, "/v1/claims", "Creates a claim"
  param :claim, Hash, required: true do
    param :specialty, String
    param :photo_id, Integer
    param :status, String
    param :patient_name, String
    param :hospital, String
    param :referring_physician, String
    param :diagnoses, Array do
      param :name, String
    end
    param :most_responsible_physician, :bool
    param :procedure_on, String
    param :admission_on, String
    param :first_seen_on, String
    param :first_seen_consult, :bool
    param :last_seen_on, String
    param :last_seen_discharge, :bool
    param :icu_transfer, :bool
    param :consult_type, String
    param :consult_time_in, String
    param :consult_time_out, String
    param :consult_premium_visit, String
    param :consult_premium_first, :bool
    param :consult_premium_travel, String
    param :patient_number, String
    param :patient_province, String
    param :patient_birthday, String
    param :patient_sex, String
    param :referring_laboratory, String
    param :payment_program, String
    param :payee, String
    param :manual_review_indicator, String
    param :daily_details, Array do
      param :day, String
      param :code, String
      param :time_in, String
      param :time_out, String
      param :autogenerated, :bool
      param :fee, Integer
      param :units, Integer
      param :premiums, Array do
        param :code, String
        param :fee, Integer
        param :units, Integer
      end
    end
    param :comment, String
  end

  def create
    @interactor = CreateClaim.new(create_claim_params)
    @interactor.user = current_user
    @interactor.perform
    show @interactor.claim
  end

  api :PUT, "/v1/claims/:id", "Updates a claim"
  param :claim, Hash, required: true do
    param :specialty, String
    param :photo_id, Integer
    param :status, String
    param :patient_name, String
    param :hospital, String
    param :referring_physician, String
    param :diagnoses, Array do
      param :name, String
    end
    param :most_responsible_physician, :bool
    param :procedure_on, String
    param :admission_on, String
    param :first_seen_on, String
    param :first_seen_consult, :bool
    param :last_seen_on, String
    param :last_seen_discharge, :bool
    param :icu_transfer, :bool
    param :consult_type, String
    param :consult_time_in, String
    param :consult_time_out, String
    param :consult_premium_visit, String
    param :consult_premium_first, :bool
    param :consult_premium_travel, String
    param :patient_number, String
    param :patient_province, String
    param :patient_birthday, String
    param :patient_sex, String
    param :referring_laboratory, String
    param :payment_program, String
    param :payee, String
    param :manual_review_indicator, String
    param :daily_details, Array do
      param :day, String
      param :code, String
      param :time_in, String
      param :time_out, String
      param :autogenerated, :bool
      param :fee, Integer
      param :units, Integer
      param :premiums, Array do
        param :code, String
        param :fee, Integer
        param :units, Integer
      end
    end
    param :comment, String
  end

  def update
    # FIXME: .where(status: Claim.statuses.slice(:saved, :rejected_doctor_attention, :rejected_admin_attention).values)
    @claim = current_user.claims.find(params[:id])
    @interactor = UpdateClaim.new(@claim, update_claim_params)
    @interactor.user = current_user
    @interactor.perform
    show @interactor.claim
  end

  api :DELETE, "/v1/claims/:id", "Deletes a claim"

  def destroy
    @claim = current_user.claims.saved.find(params[:id])
    @claim.destroy
    show @claim
  end

  private

  def create_claim_params
    params.require(:claim).permit(:status, :specialty, :photo_id, :patient_name, :hospital, :referring_physician, :procedure_on, :admission_on, :first_seen_on, :first_seen_consult, :last_seen_on, :most_responsible_physician, :last_seen_discharge, :icu_transfer, :consult_type, :consult_time_in, :consult_time_out, :consult_premium_visit, :consult_premium_first, :consult_premium_travel, :patient_number, :patient_province, :patient_birthday, :patient_sex, :referring_laboratory, :payment_program, :payee, :manual_review_indicator, :comment, daily_details: [:day, :code, :time_in, :time_out, :autogenerated, :fee, :units, premiums: [:code, :fee, :units]], diagnoses: [:name])
  end

  def update_claim_params
    params.require(:claim).permit(:status, :specialty, :photo_id, :patient_name, :hospital, :referring_physician, :procedure_on, :admission_on, :first_seen_on, :first_seen_consult, :last_seen_on, :most_responsible_physician, :last_seen_discharge, :icu_transfer, :consult_type, :consult_time_in, :consult_time_out, :consult_premium_visit, :consult_premium_first, :consult_premium_travel, :patient_number, :patient_province, :patient_birthday, :patient_sex, :referring_laboratory, :payment_program, :payee, :manual_review_indicator, :comment, daily_details: [:day, :code, :time_in, :time_out, :autogenerated, :fee, :units, premiums: [:code, :fee, :units]], diagnoses: [:name])
  end
end
