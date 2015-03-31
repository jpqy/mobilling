class DailyDetailForm
  include ActiveModel::Model
  include Virtus.model
  include ValidationScopes

  def self.scalar_params
    return [
            [:uuid, String],
            [:day, String],
            [:code, String],
            [:time_in, String],
            [:time_out, String],
            [:diagnosis, String],
            [:autogenerated, :bool],
            [:fee, Integer],
            [:paid, Integer],
            [:units, Integer],
            [:message, String],
           ]
  end

  def self.all_params
    return scalar_params + [[:premiums, Array, PremiumForm.all_params]]
  end

  all_params.each do |name, type|
    if type == :bool
      attribute name, Axiom::Types::Boolean
    else
      attribute name, type
    end
  end

  validates :code, type: {is_a: String}, allow_nil: true
  validates :premiums, associated: true

  validation_scope :warnings do |s|
    # s.validates :time_in, :time_out, presence: true, if: -> { submitted? and simplified? }
    s.validates :code, format: {with: /\A[A-Za-z]\d{3}/}
    s.validates :day, date: true, format: {with: /\A\d{4}-\d{2}-\d{2}\Z/}, type: {is_a: String}, allow_nil: true
    s.validates :time_in, :time_out, time: true, format: {with: /\A\d{2}:\d{2}\Z/, type: {is_a: String}}, allow_nil: true
    s.validates :fee, :units, type: {is_a: Integer}, presence: true
    s.validates :day, :code, presence: true
    s.validates :premiums, associated: true
  end

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  def submitted?
    false
  end

  def simplified?
    false
  end

  def premiums
    (@premiums || []).map { |premium| PremiumForm.new(premium) }
  end

  def all_warnings
    has_warnings?
    warns = warnings.as_json
    premiums.each.with_index do |premium, i|
      if premium.has_warnings?
        premium.warnings.as_json.each do |key, w|
          warns["premiums.#{i}.#{key}"] = w
        end
      end
    end
    warns
  end

  def all_errors
    valid?
    errs = errors.as_json
    premiums.each.with_index do |premium, i|
      if !premium.valid?
        premium.errors.as_json.each do |key, w|
          errs["premiums.#{i}.#{key}"] = w
        end
      end
    end
    errs
  end

  def as_json(options = nil)
    attributes
  end
end
