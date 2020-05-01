class ChatMessage < ApplicationRecord
  extend Enumerize
  include PrevNode

  belongs_to :chat_tree
  has_many :messages, -> { order(created_at: :asc) }

  has_many :answers, -> { order(created_at: :asc) }, class_name: 'ChatAnswer',
                     foreign_key: :prev_message_id,
                     dependent: :destroy

  enumerize :meta_type, in: %i[plain info letter_to_manager contact_phone contact_email],
                        default: :plain,
                        predicates: true

  accepts_nested_attributes_for :messages, reject_if: :all_blank, allow_destroy: true

  def meta_type
    ActiveSupport::StringInquirer.new(read_attribute(:meta_type).to_s)
  end

  def answer_options
    answers.options&.map(&:text)
  end

  def custom_answer
    answers.find_by(meta_type: :user_input)
  end

  def talk_to_manager
    answers.find_by(meta_type: :custom_user_input)
  end

  def main_root?
    root_message? && !manual?
  end

  def manual?
    chat_tree.meta_type.manual?
  end

  def send_it?
    return false if send_at.nil?

    send_at >= Time.current
  end

  def can_be_info?
    !root_message?
  end

  def meta_type_options
    default_options = self.class.enumerized_attributes[:meta_type].options
    return default_options unless root_message?

    default_options.reject { |option| option.last == 'info' }
  end

  def meta_type_training
    default_options = self.class.enumerized_attributes[:meta_type].options
    return default_options unless root_message?

    types = ['plain','training','training_test']
    default_options.select { |option| types.include?(option.last) }
  end

  def detect_answer_by_text(text)
    answers.options.find_by(text: text) || custom_answer
  end
end
