class Settings < ApplicationRecord
  before_validation :sanitize

  validates :email, :email_header_from, :server_url, :start_custom_message, presence: true
  # validate :check_email_header_from

  def self.get
    first || new
  end

  private

  def sanitize
    fields = [ :email ]

    fields.each do |attribute|
      self[attribute] = Sanitize.clean self[attribute], elements: ['br']
    end
  end

  def check_email_header_from
    host = ActionMailer::Base.default_url_options[:host].split(':')[0]
    unless self.email_header_from.include?(host)
      errors.add(:email_header_from, :wrong_host, host: host)
    end
  end
end
