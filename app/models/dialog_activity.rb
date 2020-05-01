class DialogActivity
  PREFIX = 'last_dialog_activity'

  def initialize(adapter, user_id)
    @adapter = adapter
    @user_id = user_id
  end

  def self.detect_inactive_states(date_from)
    states = []
    $redis.scan_each(match: "#{PREFIX}*") do |activity_key|
      last_dialog_activity = Time.parse($redis.get(activity_key))
      next if last_dialog_activity > date_from
      _, adapter, key = activity_key.split(':')
      states << DialogState.new(adapter, key)
    end
    states
  end

  def updates
    $redis.set(key, Time.now)
  end

  def drop
    $redis.del(key)
  end

  def key
    "#{PREFIX}:#{@adapter}:#{@user_id}"
  end
end
