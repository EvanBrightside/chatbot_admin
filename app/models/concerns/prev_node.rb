module PrevNode
  def self.included(klazz)
    klazz.class_eval do
      has_one :prev_script, as: :next_node, class_name: 'ChatScript'
      has_one :prev_answer, as: :next_node, class_name: 'ChatAnswer'
    end
  end

  def prev_node
    prev_script || prev_answer&.prev_message
  end

  def prev_block
    prev_script || prev_answer
  end

  def signature
    [id, self.class].join(",")
  end
end
