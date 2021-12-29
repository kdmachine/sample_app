class User < ApplicationRecord
  PROPERTIES = %i(name email password password_confirmation).freeze
  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.settings.name_maximun_length}
  validates :email, presence: true,
    length: {maximum: Settings.settings.email_maximun_length},
    format: {with: Settings.settings.email_regex},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.settings.password_minimun},
    allow_nil: true, if: :password
  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
