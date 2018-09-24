Devise.setup do |config|
  # ==> Security Extension
  # Configure security extension for devise
  config.secret_key = '4dfcacf9d92d1058cf05bccdcab87f88cfe31e58cd7b75c681a6133af48e4235b4cd48c1a866cd040347688b0e33be6e9e82ff5735fc6acd88d62c5c9fc8dc18'
  # Should the password expire (e.g 3.months)
  # config.expire_password_after = false
  config.expire_password_after = 1.year

  # Need 1 char of A-Z, a-z and 0-9
  # config.password_regex = /(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])/

  # How many passwords to keep in archive
  #config.password_archiving_count = 5

  # Deny old password (true, false, count)
  # config.deny_old_passwords = true

  # enable email validation for :secure_validatable. (true, false, validation_options)
  # dependency: need an email validator like rails_email_validator
  # config.email_validation = true
  # captcha integration for recover form
  # config.captcha_for_recover = true

  # captcha integration for sign up form
  # config.captcha_for_sign_up = true

  # captcha integration for sign in form
  # config.captcha_for_sign_in = true

  # captcha integration for unlock form
  # config.captcha_for_unlock = true

  # captcha integration for confirmation form
  # config.captcha_for_confirmation = true

  # Time period for account expiry from last_activity_at
  # config.expire_after = 90.days
end

module Devise
  module Models
    module PasswordExpirable
      def need_change_password?
        self.administrator? && password_expired?
      end 

      def password_expired?
        self.password_changed_at < self.expire_password_after.ago
      end
    end

    module SecureValidatable
      def self.included(base)
        base.extend ClassMethods
        assert_secure_validations_api!(base)
        base.class_eval do
          validate :current_equal_password_validation
        end
      end

      def current_equal_password_validation
        if !self.new_record? && !self.encrypted_password_change.nil? && !self.erased?
          dummy = self.class.new
          dummy.encrypted_password = self.encrypted_password_change.first
          dummy.password_salt = self.password_salt_change.first if self.respond_to? :password_salt_change and not self.password_salt_change.nil?
          self.errors.add(:password, :equal_to_current_password) if dummy.valid_password?(self.password)
        end
      end
    end
  end
end