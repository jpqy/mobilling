class Admin::CreateAdminUser
  include ActiveModel::Model

  attr_accessor :email, :password, :name, :role
  attr_reader :admin_user

  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :password, confirmation: true, presence: true
  validates :role, inclusion: {in: Admin::User.roles.keys}
  validate :existence

  def initialize(attributes = nil)
    @admin_user = Admin::User.new
    super(attributes)
  end

  def perform
    if valid?
      @admin_user.update!(admin_user_attributes)
    else
      false
    end
  end

  private

  def admin_user_attributes
    {
      name: name,
      email: email.to_s.downcase,
      password: password,
      role: role
    }
  end

  def existence
    errors.add :email, :taken if Admin::User.where(email: email.to_s.downcase).exists?
  end
end