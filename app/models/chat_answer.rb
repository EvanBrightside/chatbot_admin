class ChatAnswer < ApplicationRecord
  extend Enumerize

  belongs_to :chat_tree, optional: true

  belongs_to :prev_message, class_name: "ChatMessage", optional: true
  belongs_to :next_node, polymorphic: true, dependent: :destroy, optional: true # script or message
  belongs_to :link_node, polymorphic: true, optional: true # script or message

  enumerize :meta_type, in: [:user_input, :option, :link, :link_to_back, :link_to_start, :custom_user_input],
                        default: :option,
                        predicates: true,
                        scope: true

  enumerize :valid_regexp, in: [:email, :phone, :emailorphone]

  validates :text, length: { maximum: 35 }

  VALID_REGEXPS = {
    email: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
    phone: /\b^([0-9]{11})$\b|\+^*([0-9]{10})\d/,
    emailorphone: /(\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z)|(\b^([0-9]{11})$\b)/i
  }

  scope :options, -> { with_meta_type(:option, :link, :link_to_back, :link_to_start) } # show options

  def meta_type
    ActiveSupport::StringInquirer.new(read_attribute(:meta_type).to_s)
  end

  def prev_nodes
    nodes = []
    node = prev_message
    loop do
      return nodes unless node
      nodes << node
      node = node.prev_node
    end
  end

  def any_nodes
    ChatMessage.all + ChatTree.all
  end

  def link_node=(value)
    if value.is_a?(String)
      self.link_node_id, self.link_node_type = value.split(',')
    else
      super
    end
  end

  def check_text_format(text)
    return true unless valid_regexp && user_input?

    regexp = VALID_REGEXPS[valid_regexp.to_sym]
    return true unless regexp

    regexp =~ text
  end

  def meta_type_options
    default_options = self.class.enumerized_attributes[:meta_type].options
    default_options.reject { |option| option.last == 'event' }
  end
end
