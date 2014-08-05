class CreateUser
  include ActiveModel::Model

  attr_accessor :email, :password, :name, :agent_id
  attr_reader :user

  validates :email, presence: true, email: true
  validates :agent_id, presence: true
  validates :password, presence: true
  validates :name, presence: true
  validate :existence

  def perform
    @user = User.find_or_initialize_by(email: email.to_s.downcase)
    if valid?
      @user.update!(user_params)
    else
      false
    end
  end

  private

  def user_params
    {
      password: password,
      name: name,
      agent_id: agent_id,
      authentication_token: SecureRandom.hex(32)
    }
  end

  def existence
    errors.add :email, :taken if user.persisted?
  end
end
