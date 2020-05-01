class Message < ApplicationRecord
  extend Enumerize

  belongs_to :chat_message, optional: true
  belongs_to :custom_message, optional: true

  enumerize :meta_type, in: [:text, :file, :photo],
                        default: :text,
                        predicates: true

  scope :for_adapter, ->(adapter) { where("adapters ->> ? = '1'", adapter) }

  scope :sorted, -> { order('id ASC') }

  mount_uploader :file, MessageFileUploader
  mount_uploader :photo, MessagePhotoUploader

  validates :text, presence: true, if: -> { meta_type.text? }

  def for_dialog
    {
      chat_type: chat_message.meta_type,
      type: meta_type,
      timer: timer,
      text: text,
      file: file,
      photo: photo
    }
  end
end
