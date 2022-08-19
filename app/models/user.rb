class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.validates.max_name}

  validates :email, presence: true,
    length: {maximum: Settings.validates.max_email},
    format: {with: Settings.regex.VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
    length: {minimum: Settings.validates.min_password},
    if: :password

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
